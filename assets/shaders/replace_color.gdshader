// 颜色替换着色器 - 用于替换精灵中的特定颜色
// 主要用于更改队伍颜色和球员皮肤颜色
shader_type canvas_item;

// 调色板组 - 包含皮肤和队伍颜色的调色板纹理
group_uniforms Palettes;
uniform sampler2D skin_palette; // 皮肤颜色调色板，第一行为参考色，其他行为替换色
uniform sampler2D team_palette; // 队伍颜色调色板，第一行为参考色，其他行为替换色
group_uniforms;

uniform int skin_color : hint_enum("Light", "Medium", "Dark"); // 皮肤颜色选择
uniform int team_color; // 队伍颜色选择索引

// 将像素坐标转换为UV坐标
// pos: 像素位置
// tex_size: 纹理尺寸
vec2 px_to_uv(ivec2 pos, ivec2 tex_size) {
	return vec2(
		// 加0.5取像素中心点
		(float(pos[0]) + 0.5) / float(tex_size[0]),
		(float(pos[1]) + 0.5) / float(tex_size[1])
	);
}

// 根据调色板替换颜色
// color: 当前像素颜色
// palette: 调色板纹理
// selection: 在调色板中选择的行索引
vec4 get_palette_color(vec4 color, sampler2D palette, int selection) {
	ivec2 tex_size = textureSize(palette, 0);

	// 遍历调色板第一行的参考色，找到匹配的颜色并返回替换颜色
	for (int i = 0; i < tex_size[0]; i++) {
		vec2 uv_color_ref = px_to_uv(ivec2(i, 0), tex_size);
		vec4 color_ref = texture(palette, uv_color_ref);
		if (color == color_ref) {
			vec2 uv_color_dest = px_to_uv(ivec2(i, selection), tex_size);
			return texture(palette, uv_color_dest);
		}
	}

	return color; // 如果没有匹配的颜色，返回原始颜色
}

// 片段着色器主函数 - 处理每个像素
void fragment() {
	// 首先应用队伍颜色替换
	COLOR = get_palette_color(COLOR, team_palette, team_color);

	// 如果选择了非默认皮肤颜色，应用皮肤颜色替换
	if (skin_color > 0) {
		COLOR = get_palette_color(COLOR, skin_palette, skin_color);
	}
}