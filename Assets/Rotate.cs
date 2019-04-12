using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
	void Update()
	{
		transform.Rotate(0.0f, Time.deltaTime * 60.0f, 0.0f);
	}
}
