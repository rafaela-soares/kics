package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service_account[name]

	resource.metadata.name == "default"

	not common_lib.valid_key(resource, "automount_service_account_token")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_service_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_service_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is set", [name]),
		"keyActualValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service_account[name]

	resource.metadata.name == "default"

	resource.automount_service_account_token == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_service_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_service_account[%s].automount_service_account_token", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is set to false", [name]),
		"keyActualValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is not set to false", [name]),
	}
}
