using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour
{
	void Update()
	{
		transform.Rotate(Vector3.right * Time.deltaTime * 90.0f, Space.Self);
	}
}
