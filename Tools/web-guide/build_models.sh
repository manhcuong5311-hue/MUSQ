#!/bin/zsh
# Every row of exercises.tsv: app model -> branded, packed, stamped GLB in the site repo.
#   build_models.sh [slug ...]      (no slugs: every row)
# Needs Blender 5.1 and npx (gltfpack is fetched by npx).
HERE=${0:A:h}
M=${HERE:h:h}/GymWorkout/Resources/Models
SITE=${SITE:-${HERE:h:h:h}/musq-site}/exercises
STAGE=${TMPDIR:-/tmp}/musq-web-stage
mkdir -p $STAGE
while IFS=$'\t' read -r slug title model body yaw; do
  [[ -z $slug ]] && continue
  (( $# )) && [[ ${@[(Ie)$slug]} -eq 0 ]] && continue
  name=${model:t}
  mkdir -p $STAGE/$name $SITE/$slug
  # The slim model references its shared body file, which must sit beside it.
  cp -c $M/$model.usdc $STAGE/$name/ 2>/dev/null || cp $M/$model.usdc $STAGE/$name/
  [[ -e $STAGE/$name/$body.usdc ]] || cp -c $M/Shared/$body.usdc $STAGE/$name/ 2>/dev/null || cp $M/Shared/$body.usdc $STAGE/$name/
  /Applications/Blender.app/Contents/MacOS/Blender -b --factory-startup --python $HERE/web_export.py -- \
    $STAGE/$name/$name.usdc $STAGE/raw-$slug.glb $yaw 2>&1 | grep -E "WEB_EXPORT|PRINT|Error|Traceback"
  (cd $STAGE && npx -y gltfpack -i raw-$slug.glb -o $SITE/$slug/musq-$slug.glb -cc -af 24 2>&1 | grep -v "^Warning")
  python3 $HERE/stamp.py $SITE/$slug/musq-$slug.glb "$title"
  print -- "DONE $slug $(( $(stat -f %z $SITE/$slug/musq-$slug.glb) / 1024 ))KB"
  rm -f $STAGE/raw-$slug.glb
done < $HERE/exercises.tsv
