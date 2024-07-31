<?php
class TableHandler {
	public $conn;
	public $table_columns;
	public $table_name;
	public $server;
	public $username;
	public $password;
	public $db;

	function __construct($server, $username, $password, $db, $table) {
		$this->server = $server;
		$this->username = $username;
		$this->password = $password;
		$this->db = $db;
		$this->table_name = $table;
		$this->conn = new mysqli($server, $username, $password, $db);
		if ($this->conn->connect_error) {
			die("Connection failed: " . $conn->connect_error);
		}
		$query_for_columns = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, EXTRA, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='".$table."';";
		$result = $this->conn->query($query_for_columns);
		$this->table_columns = array();
		foreach ($result as $column) {
			$a = false;
			if (strcmp("auto_increment", $column["EXTRA"]) == 0) {
				$a = true;
			}
			$b = false;
			if (strcmp("YES", $column["IS_NULLABLE"]) == 0) {
				$b = true;
			}
			array_push($this->table_columns, array($column["COLUMN_NAME"], $column["DATA_TYPE"], $column["CHARACTER_MAXIMUM_LENGTH"], $a, $b));
		}
		$this->conn->close();
	}

	function insert_generate_prepared_statement() {
		$query = "INSERT INTO ".$this->table_name."(";
		foreach ($this->table_columns as $i) {
			if (!$i[3]){
				$query = $query.$i[0].',';
			}
		}
		$query = substr_replace($query, '', -1);
		$query = $query.") VALUES (";
		foreach ($this->table_columns as $i) {
			if (!$i[3]){
				$query = $query."?,";
			}
		}
		$query = substr_replace($query, ')', -1);
		return $query;
	}

	function insert_generate_bind_param_args() {
		$param = "'";
		foreach ($this->table_columns as $i) {
			if (!$i[3]){
				if(!strcmp($i[1], "varchar") || !strcmp($i[1], "char") || !strcmp($i[1], "date") || !strcmp($i[1], "timestamp")) {
					$param .= "s";
				} elseif (!strcmp($i[1], "int")) {
					$param .= "i";
				} else {
					
					die("huh????: ".$i[1]);
				}
			}
		}
		$param .= "', ";
		foreach ($this->table_columns as $i) {
			if (!$i[3]){
				$param .= "\$_POST['".$i[0]."'],";
			}
		}
		$param = substr_replace($param, '', -1);
		return $param;
	}

	function generate_sql_connection_code() {
		$code = "";
		$code .= "echo \"<a href='index.php'>Home</a><br>\";\n";
		$code .= "echo \"<a href='manage.php'>Manage</a><br>\";\n";
		$code .= "\$s = '".$this->server."';\n";
		$code .= "\$u = '".$this->username."';\n";
		$code .= "\$p = '".$this->password."';\n";
		$code .= "\$d = '".$this->db."';\n";
		$code .= "\$conn = new mysqli(\$s, \$u, \$p, \$d);\n";
		$code .= "if (\$conn->connect_error) {\n\tdie('Connection failed: ' . \$conn->connect_error);\n}\n";
		$code .= "\$select_statement = 'SELECT * FROM ".$this->table_name."';\n";
		$code .= "\$insert_statement = \$conn->prepare('".$this->insert_generate_prepared_statement()."');\n";
		$code .= "\$insert_statement->bind_param(".$this->insert_generate_bind_param_args().");\n";
		$code .= "if(isset(\$_POST['insert_form_submit'])) {\n";
		$code .= "\ttry{";
		$code .= "\t\t\$insert_statement->execute();\n";
		$code .= "\t\t\$insert_statement->close();\n";
		$code .= "\t\theader('Refresh:0');\n";
		$code .= "\t} catch (Exception \$e) {\n";
		$code .= "\n\t\techo \"Wrong manipulation of db: \".\$e->getMessage().\"<br><br>\";\n";
		$code .= "\t}\n";
		$code .= "}\n";
		$code .= "if(isset(\$_POST['delete_form_submit'])) {\n";
		$code .= "\t\$type = gettype(\$_POST['delete_'.\$_POST['delete_select']]);\n";
		$code .= "\tif(!strcmp(\$type, 'string')) {\n";
		$code .= "\t\t\$type = '\''.\$_POST['delete_'.\$_POST['delete_select']].'\'';\n";
		$code .= "\t} elseif (!strcmp(\$type, 'integer')) {\n";
		$code .= "\t\t\$type = \$_POST['delete_'.\$_POST['delete_select']];\n";
		$code .= "\t} else {\n\tdie('huh????');\n\t}\n";
		$code .= "\ttry{\n";
		$code .= "\t\tif(!\$conn->query(\"DELETE FROM ".$this->table_name." WHERE \".\$_POST['delete_select'].\" = \".\$type.\"\")) {\n";
		$code .= "\t\t\tdie('huh????');\n";
		$code .= "\t\t}\n";
		$code .= "\t\theader('Refresh:0');\n";
		$code .= "\n\t} catch (Exception \$e) {\n";
		$code .= "\n\t\techo \"Wrong manipulation of db: \".\$e->getMessage().\"<br><br>\";\n";
		$code .= "\n\t}\n";
		$code .= "\n}\n";
		$code .= "if(isset(\$_POST['update_form_submit'])) {\n";
		$code .= "\t\$a = '';\n";
		$code .= "\t\$type = gettype(\$_POST['update_new_val_'.\$_POST['update_select_new_val']]);\n";
		$code .= "\tif(!strcmp(\$type, 'string')) {\n";
		$code .= "\t\t\$a = '\''.\$_POST['update_new_val_'.\$_POST['update_select_new_val']].'\'';\n";
		$code .= "\t} elseif (!strcmp(\$type, 'integer')) {\n";
		$code .= "\t\t\$a = \$_POST['update_new_val_'.\$_POST['update_select_new_val']];\n";
		$code .= "\t} else {\n\tdie('huh????');\n\t}\n";
		$code .= "\t\$b = '';\n";
		$code .= "\t\$type = gettype(\$_POST['update_condition_'.\$_POST['update_select_condition']]);\n";
		$code .= "\tif(!strcmp(\$type, 'string')) {\n";
		$code .= "\t\t\$b = '\''.\$_POST['update_condition_'.\$_POST['update_select_condition']].'\'';\n";
		$code .= "\t} elseif (!strcmp(\$type, 'integer')) {\n";
		$code .= "\t\t\$b = \$_POST['update_condition_'.\$_POST['update_select_condition']];\n";
		$code .= "\t} else {\n\tdie('huh????');\n}\n";
		$code .= "\ttry{\n";
		$code .= "\t\$conn->query(\"UPDATE ".$this->table_name." SET \".\$_POST['update_select_new_val'].\" = \".\$a.\" WHERE \".\$_POST['update_select_condition'].\" = \".\$b.\"\");\n";
		$code .= "\theader('Refresh:0');\n";
		$code .= "\n\t} catch (Exception \$e) {\n";
		$code .= "\n\t\techo \"Wrong manipulation of db: \".\$e->getMessage().\"<br><br>\";\n";
		$code .= "\n\t}\n";
		$code .= "\n}\n";
		return $code;
	}

	function show_form_insert() {
		$form = "<form action='' method='POST'>\n";
		foreach ($this->table_columns as $i) {
			if (!$i[3]){
				$input = "\t".$i[0].":<input name='".$i[0]."' ";
				if(!strcmp($i[1], "varchar") || !strcmp($i[1], "char") || !strcmp($i[1], "timestamp") ) {
					$input = $input." type='text' maxlength='".$i[2]."' ";
					if (!strcmp($i[1], "char")) {
						$input = $input." minlength='".$i[2]."' ";
					}
				} elseif (!strcmp($i[1], "date")) {
					$input = $input." type='date' ";
				} elseif (!strcmp($i[1], "int")) {
					$input = $input." type='number' ";
				} else {
					die("huh????");
				}
				$req = "required";
				if ($i[4]) {
					$req = "";
				}
				$input = $input." ".$req."><br>\n";
				$form = $form.$input;
			}
		}
		$form = $form."\t<input type='submit' name='insert_form_submit'><br>\n</form>\n";
		return $form;
	}

	function select_data_html() {
		$code = "<?php\n";
		$code .= "\$select_data = \$conn->query(\$select_statement);\n";
		$code .= "echo '<table>';\n";
		$code .= "\$row = \$select_data->fetch_assoc();\n";
		$code .= "echo '<tr>';\n";
		$code .= "foreach(\$row as \$k => \$v) {\n";
		$code .= "\techo '<th>'.\$k.'</th>';\n";
		$code .= "}\n";
		$code .= "echo '</tr>';\n";
		$code .= "do {\n";
		$code .= "\techo '<tr>';\n";
		$code .= "\tforeach(\$row as \$d) {\n";
		$code .= "\t\techo '<td>'.\$d.'</td>';\n";
		$code .= "\t}\n";
		$code .= "\techo '</tr>';\n";
		$code .= "}while (\$row = \$select_data->fetch_assoc());\n";
		$code .= "echo '</table>';\n";
		$code .= "?>\n";
		return $code;
	}

	function delete_form() {
		$form = "Delete: <form action='' method='POST'>\n";
		$form .= "\t<select name='delete_select' onchange='select_input_delete(event)'>\n";
		$form .= "\t\t<option disabled selected> Delete by </option>\n";
		foreach ($this->table_columns as $i) {
			$form .= "\t\t<option value='".$i[0]."'> ".$i[0]." </option>\n";
		}
		$form .= "\t</select>\n";
		$form .= "<div id='input_delete'>\n";
		$form .= "\t\n";
		$form .= "</div>\n";
		$form .= "\t<input type='submit' name='delete_form_submit'><br>\n</form>\n";
		return $form;
	}

	function update_form() {
		$form = "Update: <form action='' method='POST'>\n";
		$form .= "\t<select name='update_select_condition' onchange='select_input_update_cond(event)'>\n";
		$form .= "\t\t<option disabled selected> Update condition </option>\n";
		foreach ($this->table_columns as $i) {
			$form .= "\t\t<option value='".$i[0]."'> ".$i[0]." </option>\n";
		}
		$form .= "\t</select>\n";
		$form .= "<div id='input_update_condition'>\n";
		$form .= "\t\n";
		$form .= "</div>\n";
		$form .= "\t<select name='update_select_new_val' onchange='select_input_update_new(event)'>\n";
		$form .= "\t\t<option disabled selected> Update new value </option>\n";
		foreach ($this->table_columns as $i) {
			$form .= "\t\t<option value='".$i[0]."'> ".$i[0]." </option>\n";
		}
		$form .= "\t</select>\n";
		$form .= "<div id='input_update_new_val'>\n";
		$form .= "\t\n";
		$form .= "</div>\n";
		$form .= "\t<input type='submit' name='update_form_submit'><br>\n</form>\n";
		return $form;
	}

	function generate_js() {
		$js = "<script>\n";
		$js .= "\tfunction select_input_delete(e) {\n";
		$js .= "\t\tswitch(e.target.value) {\n";
		foreach ($this->table_columns as $i) {
			$js .= "\t\t\tcase '".$i[0]."':\n";
			$js .= "\t\t\t\tdocument.getElementById('input_delete').innerHTML = \n";
			$js .= "\t\t\t\t\t\"<input name='delete_".$i[0]."' ";
			if(!strcmp($i[1], "varchar") || !strcmp($i[1], "char") || !strcmp($i[1], "timestamp")) {
				$js .= " type='text' maxlength='".$i[2]."' ";
				if (!strcmp($i[1], "char")) {
					$js .= " minlength='".$i[2]."' ";
				}
			} elseif (!strcmp($i[1], "date")) {
				$js .= " type='date' ";
			} elseif (!strcmp($i[1], "int")) {
				$js .= " type='number' ";
			} else {
				die("huh????");
			}
			$js .= " required><br>\";\n";
			$js .= "\t\t\tbreak;\n";
		}
		$js .= "\t\t}\n";
		$js .= "\t}\n";
		$js .= "\tfunction select_input_update_new(e) {\n";
		$js .= "\t\tswitch(e.target.value) {\n";
		foreach ($this->table_columns as $i) {
			$js .= "\t\t\tcase '".$i[0]."':\n";
			$js .= "\t\t\t\tdocument.getElementById('input_update_new_val').innerHTML = \n";
			$js .= "\t\t\t\t\t\"<input name='update_new_val_".$i[0]."' ";
			if(!strcmp($i[1], "varchar") || !strcmp($i[1], "char") || !strcmp($i[1], "timestamp")) {
				$js .= " type='text' maxlength='".$i[2]."' ";
				if (!strcmp($i[1], "char")) {
					$js .= " minlength='".$i[2]."' ";
				}
			} elseif (!strcmp($i[1], "date")) {
				$js .= " type='date' ";
			} elseif (!strcmp($i[1], "int")) {
				$js .= " type='number' ";
			} else {
				die("huh????");
			}
			$js .= " required><br>\";\n";
			$js .= "\t\t\tbreak;\n";
		}
		$js .= "\t\t}\n";
		$js .= "\t}\n";
		$js .= "\tfunction select_input_update_cond(e) {\n";
		$js .= "\t\tswitch(e.target.value) {\n";
		foreach ($this->table_columns as $i) {
			$js .= "\t\t\tcase '".$i[0]."':\n";
			$js .= "\t\t\t\tdocument.getElementById('input_update_condition').innerHTML = \n";
			$js .= "\t\t\t\t\t\"<input name='update_condition_".$i[0]."' ";
			if(!strcmp($i[1], "varchar") || !strcmp($i[1], "char") || !strcmp($i[1], "timestamp")) {
				$js .= " type='text' maxlength='".$i[2]."' ";
				if (!strcmp($i[1], "char")) {
					$js .= " minlength='".$i[2]."' ";
				}
			} elseif (!strcmp($i[1], "date")) {
				$js .= " type='date' ";
			} elseif (!strcmp($i[1], "int")) {
				$js .= " type='number' ";
			} else {
				die("huh????");
			}
			$js .= " required><br>\";\n";
			$js .= "\t\t\tbreak;\n";
		}
		$js .= "\t\t}\n";
		$js .= "\t}\n";
		$js .= "</script>\n";
		return $js;
	}

	function generate_page() {
		$page = "<html><head><title>".$this->table_name."</title></head><body>";
		$page .= "<?php\n".$this->generate_sql_connection_code()."\n?>\n";
		$page .= $this->show_form_insert();
		$page .= "<br><br><br>\n";
		$page .= $this->update_form();
		$page .= "<br><br><br>\n";
		$page .= $this->delete_form();
		$page .= "<br><br><br>\n";
		$page .= $this->select_data_html();
		$page .= $this->generate_js();
		$page .= "</body></html>";
		return $page;
	}
}
$arr = array (
	"ClubMember",
	"ClubMemberPartOfTeam",
	"Email",
	"FamilyMember",
	"GeneralManagement",
	"Location",
	"LocationOperatingStaff",
	"Personnel",
	"RegistrationAtLocation",
	"SecondaryFamilyMember",
	"Session",
	"Team",
	"Users",
);
$a = fopen("manage.php", "w") or die("huh");
fwrite($a, "<html><head><title>manage</title></head><body><a href='./index.php'>Home</a><br><br>");
foreach($arr as $b) {
	fwrite($a, "<a href = './".$b.".php'>".$b."</a><br>");
}
fwrite($a, "</body></html>");
foreach($arr as $i) {
	$t = new TableHandler("localhost", "php", "php", "php_db", $i);
	$f = fopen($i.".php", "w") or die("huh");
	fwrite($f, $t->generate_page());
}
/*echo $v->insert_generate_prepared_statement();*/
/*echo $v->show_form_insert();*/
/*echo $v->generate_js();*/
?>
