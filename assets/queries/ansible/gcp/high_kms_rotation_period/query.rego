package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_kms_crypto_key", "gcp_kms_crypto_key"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	rotation_period := substring(instance.rotation_period, 0, count(instance.rotation_period) - 1)
	seconds_in_a_year := 315356000
	to_number(rotation_period) > seconds_in_a_year

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rotation_period", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_kms_crypto_key.rotation_period is at most '315356000s'",
		"keyActualValue": "gcp_kms_crypto_key.rotation_period is greater than '315356000s'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	not common_lib.valid_key(instance, "rotation_period")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_kms_crypto_key.rotation_period is set",
		"keyActualValue": "gcp_kms_crypto_key.rotation_period is undefined",
	}
}
