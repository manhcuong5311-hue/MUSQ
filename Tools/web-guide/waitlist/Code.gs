// MUSQ waitlist for the web exercise guide.
// The pages POST an email here and GET the signup count. Emails stay in this
// sheet: nothing below ever returns them, only the count.

const SHEET = 'Waitlist';

function sheet_() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sh = ss.getSheetByName(SHEET);
  if (!sh) sh = ss.insertSheet(SHEET);
  if (sh.getLastRow() === 0) {
    sh.appendRow(['Email', 'Signed up', 'Page']);
    sh.setFrozenRows(1);
  }
  return sh;
}

function count_(sh) {
  return Math.max(0, sh.getLastRow() - 1);
}

function json_(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}

function doGet() {
  const cache = CacheService.getScriptCache();
  let n = cache.get('count');
  if (n === null) {
    n = String(count_(sheet_()));
    cache.put('count', n, 60);
  }
  return json_({ count: Number(n) });
}

function doPost(e) {
  let data = {};
  try {
    data = JSON.parse(e.postData.contents);
  } catch (err) {
    data = e.parameter || {};
  }
  const sh = sheet_();
  // Bots fill the hidden "website" field; humans never see it.
  if (data.website) return json_({ ok: true, count: count_(sh) });

  const email = String(data.email || '').trim().toLowerCase();
  if (email.length > 254 || !/^[a-z0-9][a-z0-9._%+-]{0,63}@[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,}$/.test(email)) {
    return json_({ ok: false, error: 'invalid', count: count_(sh) });
  }
  // Only path characters, so nothing written can start a formula.
  const page = String(data.page || '').replace(/[^a-z0-9\/_-]/gi, '').slice(0, 120);

  const lock = LockService.getScriptLock();
  lock.waitLock(10000);
  try {
    const n = count_(sh);
    const known = n > 0 && sh.getRange(2, 1, n, 1).getValues().some(function (r) { return r[0] === email; });
    if (!known) sh.appendRow([email, new Date(), page]);
    const total = count_(sh);
    CacheService.getScriptCache().put('count', String(total), 60);
    return json_({ ok: true, already: known, count: total });
  } finally {
    lock.releaseLock();
  }
}
