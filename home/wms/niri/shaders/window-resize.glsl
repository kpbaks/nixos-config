// https://github.com/sodiboo/nix-config/blob/3d25eaf71cc27a0159fd3449c9d20ac4a8a873b5/niri.mod.nix#L196C11-L232C14
vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
  vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

  vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
  vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

  // We can crop if the current window size is smaller than the next window
  // size. One way to tell is by comparing to 1.0 the X and Y scaling
  // coefficients in the current-to-next transformation matrix.
  bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
  bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

  vec3 coords = coords_stretch;
  if (can_crop_by_x)
      coords.x = coords_crop.x;
  if (can_crop_by_y)
      coords.y = coords_crop.y;

  vec4 color = texture2D(niri_tex_next, coords.st);

  // However, when we crop, we also want to crop out anything outside the
  // current geometry. This is because the area of the shader is unspecified
  // and usually bigger than the current geometry, so if we don't fill pixels
  // outside with transparency, the texture will leak out.
  //
  // When stretching, this is not an issue because the area outside will
  // correspond to client-side decoration shadows, which are already supposed
  // to be outside.
  if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
      color = vec4(0.0);
  if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
      color = vec4(0.0);

  return color;
}
