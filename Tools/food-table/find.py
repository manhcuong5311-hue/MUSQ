#!/usr/bin/env python3
"""Search the USDA index: every word must appear in the description (case-insensitive).

  python3 -I find.py rice noodles cooked          rows whose description has all three words
  python3 -I find.py --portions 173424            typical portions (grams) for one row
  python3 -I find.py --id 173424                  one row
Columns: fdc_id, dataset (sr = SR Legacy single foods, fndds = survey foods incl. mixed dishes),
kcal, protein g, fat g, carbs g per 100 g, description, category.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))


def rows(name):
    with open(os.path.join(HERE, "usda", name), encoding="utf-8") as fh:
        next(fh)
        for line in fh:
            yield line.rstrip("\n").split("\t")


def main(args):
    if not args:
        print(__doc__)
        return 2
    if args[0] == "--portions" and len(args) == 2:
        for fid, grams, text in rows("usda_portions.tsv"):
            if fid == args[1]:
                print(f"{grams} g\t{text}")
        return 0
    if args[0] == "--id" and len(args) == 2:
        for r in rows("usda_index.tsv"):
            if r[0] == args[1]:
                print("\t".join(r))
        return 0
    words = [w.lower() for w in args]
    hits = [r for r in rows("usda_index.tsv") if all(w in r[6].lower() for w in words)]
    for r in hits[:60]:
        print(f"fdc:{r[0]}\t{r[1]}\t{r[2]} kcal\tP{r[3]} F{r[4]} C{r[5]}\t{r[6]}")
    if len(hits) > 60:
        print(f"... {len(hits) - 60} more: add words to narrow it down")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
