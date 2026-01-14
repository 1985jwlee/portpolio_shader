Unity Shader Collection (URP)
Unity Universal Render Pipeline (URP) 기반의 커스텀 셰이더 라이브러리입니다. 캐릭터 렌더링, 디졸브 이펙트, 아웃라인 등 다양한 비주얼 이펙트를 제공합니다.
📋 목차

주요 기능
셰이더 목록
설치 방법
사용 예시
기술 스택

🎨 주요 기능
1. Unit Shaders (캐릭터 렌더링)

툰 셰이딩: 커스텀 라이트 시스템과 셀 셰이딩
림 라이트: 캐릭터 윤곽 강조
다중 텍스처: Main, Emissive, Mask, Normal 텍스처 지원
커스텀 라이팅: 최대 4개의 포인트 라이트 + 1개의 디렉셔널 라이트
페이셜 애니메이션: UV 오프셋 기반 표정 전환
앰비언트 시스템: 높이 기반 그라데이션 앰비언트

2. Advanced Dissolve System

다양한 마스크 타입:

XYZ Axis
Plane (최대 4개)
Sphere (최대 4개)
Box (최대 4개)
Cylinder (최대 4개)
Cone (최대 4개)


커스터마이징 가능한 엣지:

색상 및 강도 조절
텍스처 매핑
왜곡 효과


알파 소스: Main Map, 1~3개의 커스텀 맵 지원

3. Outline System

두께 조절 가능한 아웃라인
버텍스 컬러 기반 부분 적용
스텐실 마스킹 지원
숨김 아웃라인: 가려진 부분에 다른 색상 표시

4. Shadow & Transparency

커스텀 그림자 시스템
투명도 지원: SrcAlpha OneMinusSrcAlpha 블렌딩
깊이 전용 패스: 최적화된 렌더링

📂 셰이더 목록
Unit Shaders
URPTimeDefenders/
├── UnitGeometry          - 불투명 캐릭터 (LOD 300)
├── UnitTransparent       - 투명 캐릭터
├── UnitStealth           - 스텔스 효과 (프레넬)
├── OutlineShader         - 캐릭터 아웃라인
├── ShadowShader          - 평면 그림자
├── HideOutlineColor      - 숨김 아웃라인 색상
└── HideOutlineThickness  - 숨김 아웃라인 두께
Dissolve Shaders
URPTimeDefenders/
├── Unit_Dissolve_Plane         - Plane 마스크 디졸브
├── Unit_Dissolve_Plane_Opsite  - 반전 Plane 디졸브
└── UnitTransparent_Dissolve_Noise - 노이즈 기반 디졸브
Sprite Shaders
_TimeDependers/
├── TdSpriteZwriteOn              - Z-Write 활성화 스프라이트
├── TdSpriteZwriteOnProjector     - 프로젝터용 Z-Write 스프라이트
├── TdStageBackground             - 스테이지 배경
├── TdStageBackgroundIgnoreProjector - 프로젝터 무시 배경
└── TdLobbyEarth                  - 로비 지구 (발광)
Utility Shaders
URPTimeDefenders/
└── UnlitTransparent - 범용 Unlit 투명 셰이더
🔧 설치 방법

Unity 프로젝트에서 URP 설정:

Window > Package Manager > Universal RP 설치

셰이더 파일 복사:

Assets/Shaders/ 폴더에 모든 .shader 및 .hlsl 파일 복사

머티리얼 생성:

우클릭 > Create > Material
Shader 드롭다운에서 원하는 셰이더 선택
💡 사용 예시
Unit Geometry Shader 설정
csharp// 머티리얼 프로퍼티 설정 예시
material.SetTexture("_MainTex", characterTexture);
material.SetTexture("_MaskTexture", maskTexture);
material.SetColor("_IndirectColor", new Color(0.2f, 0.2f, 0.2f));
material.SetFloat("_CelMidPoint", 0.5f);
material.SetFloat("_CelSoftness", 0.1f);

// 커스텀 라이트 설정
material.SetFloat("_UseLightMapper", 1);
material.SetVector("_DirectionLightV0", lightColor);
material.SetVector("_DirectionLightV1", lightDirection);
Dissolve Effect 설정
csharp// Plane 마스크 디졸브
material.SetFloat("_DissolveCutoff", dissolveAmount); // 0-1
material.SetVector("_DissolveMaskPosition", planePosition);
material.SetVector("_DissolveMaskNormal", planeNormal);
material.SetColor("_DissolveEdgeColor", Color.cyan);
material.SetFloat("_DissolveEdgeWidth", 0.1f);
Outline 설정
csharp// 아웃라인 머티리얼
outlineMaterial.SetFloat("_OutlineWidth", 100f);
outlineMaterial.SetColor("_OutlineColor", Color.black);
outlineMaterial.SetFloat("_OutlineLerp", 1f);
🛠️ 기술 스택

Unity URP: Universal Render Pipeline
HLSL: High Level Shading Language
Shader Graph 호환: SubGraph 지원
인스턴싱: GPU Instancing 지원
스텐실 버퍼: 복잡한 마스킹 시스템

📐 주요 기능 상세
Custom Light System
hlsl// CustomLight.hlsl에서 지원하는 라이팅
- Directional Light (1개)
- Point Light (최대 4개)
- Cel Shading (Mid Point, Softness 조절)
- Specular (Mask 텍스처 기반)
- MatCap
- Hair Ring Light (머리카락 전용)
Advanced Dissolve Parameters
ParameterTypeDescription_DissolveCutoffFloat (0-1)디졸브 진행도_DissolveEdgeWidthFloat (0-1)엣지 두께_DissolveEdgeColorColor엣지 색상_DissolveEdgeColorIntensityFloat엣지 발광 강도_DissolveMaskPositionVector3마스크 위치_DissolveMaskNormalVector3Plane 방향_DissolveNoiseStrengthFloat노이즈 강도
Stencil Usage
hlsl// Outline 시스템의 스텐실 사용 예
Stencil {
    Ref 8
    Comp Always
    Pass Replace
}

// 숨김 아웃라인
Stencil {
    Ref 8
    Comp Equal
    Pass Keep
}
🎯 최적화 팁

LOD 활용: UnitGeometry는 LOD 300으로 설정되어 있습니다
배치 프로퍼티: GPU Instancing 활성화로 드로우콜 감소
텍스처 압축: 모바일은 ASTC, PC는 DXT 사용 권장
셰이더 변형 관리: 사용하지 않는 키워드 제거

📝 라이선스
이 프로젝트는 포트폴리오 목적으로 제작되었습니다.
👤 제작자
Time Defenders Shader Team

캐릭터 렌더링 시스템
디졸브 이펙트 시스템
아웃라인 시스템

🔗 관련 링크

Unity URP Documentation
HLSL Reference


Note: 이 셰이더들은 Unity 2021.3 이상, URP 12.0 이상에서 테스트되었습니다.