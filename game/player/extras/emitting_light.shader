shader_type canvas_item;
render_mode unshaded;
 
uniform float width : hint_range(0.0, 4.0);
uniform vec4 outline_color : hint_color;
uniform float saturation_color : hint_range(1.0, 2.0);


void fragment()
{
	vec2 size = vec2(width) / vec2(textureSize(TEXTURE, 0));
	vec4 sprite_color = texture(TEXTURE, UV);
	
	
	float alpha = sprite_color.a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
	alpha += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
	alpha += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	
	vec4 final_color_saturation = vec4(mix(outline_color.rgb, sprite_color.rgb * saturation_color, sprite_color.a), clamp(alpha, 0.0, 1.0));
	
	COLOR = final_color_saturation;
	
	
	
}