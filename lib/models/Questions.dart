// class Questions {
// 	Id iId;
// 	String name;
// 	List<List> test;

// 	Questions({this.iId, this.name, this.test});

// 	Questions.fromJson(Map<String, dynamic> json) {
// 		iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
// 		name = json['name'];
// 		if (json['test'] != null) {
// 			test = new List<List>();
// 			json['test'].forEach((v) { test.add(new List.fromJson(v)); });
// 		}
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		if (this.iId != null) {
//       data['_id'] = this.iId.toJson();
//     }
// 		data['name'] = this.name;
// 		if (this.test != null) {
//       data['test'] = this.test.map((v) => v.toJson()).toList();
//     }
// 		return data;
// 	}
// }

// class Id {
// 	String oid;

// 	Id({this.oid});

// 	Id.fromJson(Map<String, dynamic> json) {
// 		oid = json['$oid'];
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		data['$oid'] = this.oid;
// 		return data;
// 	}
// }

// class Test {

// 	Test({});

// 	Test.fromJson(Map<String, dynamic> json) {
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		return data;
// 	}
// }
