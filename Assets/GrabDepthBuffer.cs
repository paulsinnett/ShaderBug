using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class GrabDepthBuffer : MonoBehaviour
{
	RenderTexture myDepthBufferCopy;
	CommandBuffer copyDepthBuffer;

	public void OnEnable()
	{
		if (myDepthBufferCopy == null)
		{
			myDepthBufferCopy = new RenderTexture(new RenderTextureDescriptor(512, 512, RenderTextureFormat.RFloat, 0));
			myDepthBufferCopy.Create();
			Shader.SetGlobalTexture("_MyDepthBufferCopy", myDepthBufferCopy);
		}

		Camera camera = GetComponent<Camera>();
		copyDepthBuffer = new CommandBuffer();
		copyDepthBuffer.name = "copy depth buffer";
		copyDepthBuffer.Blit(BuiltinRenderTextureType.ResolvedDepth, myDepthBufferCopy);
		camera.AddCommandBuffer(CameraEvent.BeforeLighting, copyDepthBuffer);
	}

	public void OnDisable()
	{
		if (copyDepthBuffer != null)
		{
			Camera camera = GetComponent<Camera>();
			camera.RemoveCommandBuffer(CameraEvent.BeforeLighting, copyDepthBuffer);
			copyDepthBuffer = null;
		}

		if (myDepthBufferCopy != null)
		{
			myDepthBufferCopy.Release();
			myDepthBufferCopy = null;
			Shader.SetGlobalTexture("_MyDepthBufferCopy", null);
		}
	}
}
