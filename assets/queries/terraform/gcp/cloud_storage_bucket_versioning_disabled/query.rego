package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]

	not common_lib.valid_key(resource, "versioning")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' is defined and not null",
		"keyActualValue": "'versioning' it undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]

	resource.versioning.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket[%s].versioning.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.enabled' is true",
		"keyActualValue": "'versioning.enabled' is false",
	}
}
