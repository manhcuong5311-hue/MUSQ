/** A small, structurally valid JPEG for tests (not decodable pixels): JFIF,
 *  optionally EXIF/GPS, MPF, an ICC profile, a comment, a frame header of
 *  `width` × `height`, a scan and, optionally, bytes after the end. */
export function fakeJpeg(width = 1080, height = 1440, metadata = true): Buffer {
  const seg = (marker: number, payload: Buffer) => {
    const head = Buffer.from([0xff, marker, 0, 0]);
    head.writeUInt16BE(payload.length + 2, 2);
    return Buffer.concat([head, payload]);
  };
  const t = (s: string) => Buffer.from(s, "latin1");
  const none = Buffer.alloc(0);
  return Buffer.concat([
    Buffer.from([0xff, 0xd8]),
    seg(0xe0, t("JFIF\u0000\u0001\u0001\u0000\u0000\u0001\u0000\u0001\u0000\u0000")),
    metadata ? seg(0xe1, t("Exif\u0000\u0000GPSLatitude 10.7769 N, iPhone 17 Pro")) : none,
    metadata ? seg(0xe2, t("MPF\u0000secondary image offsets")) : none,
    seg(0xe2, t("ICC_PROFILE\u0000\u0001\u0001Display P3")),
    metadata ? seg(0xed, t("Photoshop 3.0\u0000IPTC city")) : none,
    metadata ? seg(0xfe, t("a comment")) : none,
    seg(0xdb, Buffer.alloc(65, 1)),
    seg(0xc0, Buffer.from([8, height >> 8, height & 255, width >> 8, width & 255, 1, 1, 0x11, 0])),
    seg(0xc4, Buffer.alloc(30, 2)),
    seg(0xda, Buffer.from([1, 1, 0, 0, 63, 0])),
    Buffer.from([0x12, 0xff, 0x00, 0x34, 0xff, 0xd0, 0x56, 0x78, 0x9a]),
    Buffer.from([0xff, 0xd9]),
    metadata ? t("APPENDED GAIN MAP JPEG") : none,
  ]);
}
