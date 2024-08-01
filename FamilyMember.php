<html><head><style>table, th, td {border:1px solid black;}</style><title>FamilyMember</title></head><body><?php
echo "<a href='index.php'><h1>Home</h1></a>";
echo "<a href='manage.php'><h1>Manage</h1></a>";
$s = 'localhost';
$u = 'php';
$p = 'php';
$d = 'php_db';
$conn = new mysqli($s, $u, $p, $d);
if ($conn->connect_error) {
	die('Connection failed: ' . $conn->connect_error);
}
$select_statement = 'SELECT * FROM FamilyMember';
$insert_statement = $conn->prepare('INSERT INTO FamilyMember(famID,secondaryFamID,secondaryFamRelation) VALUES (?,?,?)');
$insert_statement->bind_param('iis', $_POST['famID'],$_POST['secondaryFamID'],$_POST['secondaryFamRelation']);
if(isset($_POST['insert_form_submit'])) {
	try{		$insert_statement->execute();
		$insert_statement->close();
		header('Refresh:0');
	} catch (Exception $e) {

		echo "Wrong manipulation of db: ".$e->getMessage()."<br><br>";
	}
}
if(isset($_POST['delete_form_submit'])) {
	$type = gettype($_POST['delete_'.$_POST['delete_select']]);
	if(!strcmp($type, 'string')) {
		$type = '\''.$_POST['delete_'.$_POST['delete_select']].'\'';
	} elseif (!strcmp($type, 'integer')) {
		$type = $_POST['delete_'.$_POST['delete_select']];
	} else {
	die('huh????');
	}
	try{
		if(!$conn->query("DELETE FROM FamilyMember WHERE ".$_POST['delete_select']." = ".$type."")) {
			die('huh????');
		}
		header('Refresh:0');

	} catch (Exception $e) {

		echo "Wrong manipulation of db: ".$e->getMessage()."<br><br>";

	}

}
if(isset($_POST['update_form_submit'])) {
	$a = '';
	$type = gettype($_POST['update_new_val_'.$_POST['update_select_new_val']]);
	if(!strcmp($type, 'string')) {
		$a = '\''.$_POST['update_new_val_'.$_POST['update_select_new_val']].'\'';
	} elseif (!strcmp($type, 'integer')) {
		$a = $_POST['update_new_val_'.$_POST['update_select_new_val']];
	} else {
	die('huh????');
	}
	$b = '';
	$type = gettype($_POST['update_condition_'.$_POST['update_select_condition']]);
	if(!strcmp($type, 'string')) {
		$b = '\''.$_POST['update_condition_'.$_POST['update_select_condition']].'\'';
	} elseif (!strcmp($type, 'integer')) {
		$b = $_POST['update_condition_'.$_POST['update_select_condition']];
	} else {
	die('huh????');
}
	try{
	$conn->query("UPDATE FamilyMember SET ".$_POST['update_select_new_val']." = ".$a." WHERE ".$_POST['update_select_condition']." = ".$b."");
	header('Refresh:0');

	} catch (Exception $e) {

		echo "Wrong manipulation of db: ".$e->getMessage()."<br><br>";

	}

}

?>
<form action='' method='POST'>
	famID:<input name='famID'  type='number'  required><br>
	secondaryFamID:<input name='secondaryFamID'  type='number'  ><br>
	secondaryFamRelation:<input name='secondaryFamRelation'  type='text' maxlength='256'  ><br>
	<input type='submit' name='insert_form_submit'><br>
</form>
<br><br><br>
Update: <form action='' method='POST'>
	<select name='update_select_condition' onchange='select_input_update_cond(event)'>
		<option disabled selected> Update condition </option>
		<option value='famID'> famID </option>
		<option value='secondaryFamID'> secondaryFamID </option>
		<option value='secondaryFamRelation'> secondaryFamRelation </option>
	</select>
<div id='input_update_condition'>
	
</div>
	<select name='update_select_new_val' onchange='select_input_update_new(event)'>
		<option disabled selected> Update new value </option>
		<option value='famID'> famID </option>
		<option value='secondaryFamID'> secondaryFamID </option>
		<option value='secondaryFamRelation'> secondaryFamRelation </option>
	</select>
<div id='input_update_new_val'>
	
</div>
	<input type='submit' name='update_form_submit'><br>
</form>
<br><br><br>
Delete: <form action='' method='POST'>
	<select name='delete_select' onchange='select_input_delete(event)'>
		<option disabled selected> Delete by </option>
		<option value='famID'> famID </option>
		<option value='secondaryFamID'> secondaryFamID </option>
		<option value='secondaryFamRelation'> secondaryFamRelation </option>
	</select>
<div id='input_delete'>
	
</div>
	<input type='submit' name='delete_form_submit'><br>
</form>
<br><br><br>
<?php
$select_data = $conn->query($select_statement);
echo '<table>';
$row = $select_data->fetch_assoc();
echo '<tr>';
foreach($row as $k => $v) {
	echo '<th>'.$k.'</th>';
}
echo '</tr>';
do {
	echo '<tr>';
	foreach($row as $d) {
		echo '<td>'.$d.'</td>';
	}
	echo '</tr>';
}while ($row = $select_data->fetch_assoc());
echo '</table>';
?>
<script>
	function select_input_delete(e) {
		switch(e.target.value) {
			case 'famID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_famID'  type='number'  required><br>";
			break;
			case 'secondaryFamID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_secondaryFamID'  type='number'  required><br>";
			break;
			case 'secondaryFamRelation':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_secondaryFamRelation'  type='text' maxlength='256'  required><br>";
			break;
		}
	}
	function select_input_update_new(e) {
		switch(e.target.value) {
			case 'famID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_famID'  type='number'  required><br>";
			break;
			case 'secondaryFamID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_secondaryFamID'  type='number'  required><br>";
			break;
			case 'secondaryFamRelation':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_secondaryFamRelation'  type='text' maxlength='256'  required><br>";
			break;
		}
	}
	function select_input_update_cond(e) {
		switch(e.target.value) {
			case 'famID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_famID'  type='number'  required><br>";
			break;
			case 'secondaryFamID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_secondaryFamID'  type='number'  required><br>";
			break;
			case 'secondaryFamRelation':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_secondaryFamRelation'  type='text' maxlength='256'  required><br>";
			break;
		}
	}
</script>
</body></html>