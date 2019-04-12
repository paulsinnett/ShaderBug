using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorVertices : MonoBehaviour
{
	void Start()
	{
		Mesh mesh = GetComponent<MeshFilter>().mesh;
		Color[] colors = new Color[mesh.vertices.Length];
		for (int i = 0; i < colors.Length; ++i)
		{
			colors[i] = new Color(1.0f, 0.5f, 0.1f, 1.0f);
		}
		mesh.colors = colors;
	}
}
