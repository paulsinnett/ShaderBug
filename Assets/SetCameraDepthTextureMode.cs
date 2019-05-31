using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetCameraDepthTextureMode : MonoBehaviour
{
	public DepthTextureMode mode = DepthTextureMode.None;
	new Camera camera;
	void Start()
	{
		camera = GetComponent<Camera>();
		camera.depthTextureMode = mode;
	}
}
