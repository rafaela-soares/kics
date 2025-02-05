package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	api = document.resource.aws_api_gateway_method[name]

	not common_lib.valid_key(api, "api_key_required")

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_method",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("resource.aws_api_gateway_method[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is defined", [name]),
		"keyActualValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	api = document.resource.aws_api_gateway_method[name]

	api.api_key_required != true

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_method",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("resource.aws_api_gateway_method[%s].api_key_required", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is 'false'", [name]),
	}
}
