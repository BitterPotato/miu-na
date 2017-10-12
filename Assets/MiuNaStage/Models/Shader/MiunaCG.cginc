#ifndef MIUNA_CG_INCLUDED
#define MIUNA_CG_INCLUDED

#define M_PI 3.14159265358979323846

// ==== about lights ====
// Reference: Valve
// from [-1, 1] to [0, 1]
inline fixed halfLambert(fixed value) {
	return 0.5*value + 0.5;
}

// ==== about colors ====
inline fixed4 blend(fixed4 src, fixed4 dest)
{
    return src.rgba * src.a + dest.rgba * (1.0 - src.a);
}

// ==== about transforms ====
inline float radians(uint degrees)
{
    return degrees * M_PI / 180.0;
}

void xRotate(inout float4x4 toModify, float radian)
{
    float sinv = sin(radian);
    float cosv = cos(radian);

    float4x4 rotateMatrix = float4x4(
					1.0, 0.0, 0.0, 0.0,
                    0.0, cosv, -sinv, 0.0,
					0.0, sinv, cosv, 0.0,
					0.0, 0.0, 0.0, 1.0
					);

    toModify = mul(toModify, rotateMatrix);
}

void yRotate(inout float4x4 toModify, float radian)
{
    float sinv = sin(radian);
    float cosv = cos(radian);

    float4x4 rotateMatrix = float4x4(
					cosv, 0.0, sinv, 0.0,
                    0.0, 1.0, 0.0, 0.0,
					-sinv, 0.0, cosv, 0.0,
					0.0, 0.0, 0.0, 1.0
					);

    toModify = mul(toModify, rotateMatrix);
}

void zRotate(inout float4x4 toModify, float radian) 
{
    float sinv = sin(radian);
    float cosv = cos(radian);

    float4x4 rotateMatrix = float4x4(
					cosv, -sinv, 0.0, 0.0,
                    sinv, cosv, 0.0, 0.0,
					0.0, 0.0, 1.0, 0.0,
					0.0, 0.0, 0.0, 1.0
					);

    toModify = mul(toModify, rotateMatrix);
}

// fish object space is right-hand and z axis up
void applyVelocity(inout float4x4 toModify, float3 velocity)
{
    float3 forward = normalize(velocity);
    float3 up = float3(0, 0, 1);
    // +y
    float3 sides = normalize(cross(up, forward));
    float3 uup = cross(forward, sides);
    
    float4x4 coord_trans = float4x4(
        forward.xyz, 0.0,
        sides.xyz, 0.0,
        uup.xyz, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
    toModify = mul(toModify, coord_trans);
}
#endif // MIUNA_CG_INCLUDED