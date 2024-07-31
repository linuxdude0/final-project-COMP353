<html><head><title>Personnel</title></head><body><?php
echo "<a href='index.php'>Home</a><br>";
echo "<a href='manage.php'>Manage</a><br>";
$s = 'localhost';
$u = 'php';
$p = 'php';
$d = 'php_db';
$conn = new mysqli($s, $u, $p, $d);
if ($conn->connect_error) {
	die('Connection failed: ' . $conn->connect_error);
}
$select_statement = 'SELECT * FROM Personnel';
$insert_statement = $conn->prepare('INSERT INTO Personnel(staffID,role,mandate) VALUES (?,?,?)');
$insert_statement->bind_param('iss', $_POST['staffID'],$_POST['role'],$_POST['mandate']);
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
		if(!$conn->query("DELETE FROM Personnel WHERE ".$_POST['delete_select']." = ".$type."")) {
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
	$conn->query("UPDATE Personnel SET ".$_POST['update_select_new_val']." = ".$a." WHERE ".$_POST['update_select_condition']." = ".$b."");
	header('Refresh:0');

	} catch (Exception $e) {

		echo "Wrong manipulation of db: ".$e->getMessage()."<br><br>";

	}

}

?>
<form action='' method='POST'>
	staffID:<input name='staffID'  type='number'  required><br>
	role:<input name='role'  type='text' maxlength='1024'  ><br>
	mandate:<input name='mandate'  type='text' maxlength='1024'  required><br>
	<input type='submit' name='insert_form_submit'><br>
</form>
<br><br><br>
Update: <form action='' method='POST'>
	<select name='update_select_condition' onchange='select_input_update_cond(event)'>
		<option disabled selected> Update condition </option>
		<option value='staffID'> staffID </option>
		<option value='role'> role </option>
		<option value='mandate'> mandate </option>
	</select>
<div id='input_update_condition'>
	
</div>
	<select name='update_select_new_val' onchange='select_input_update_new(event)'>
		<option disabled selected> Update new value </option>
		<option value='staffID'> staffID </option>
		<option value='role'> role </option>
		<option value='mandate'> mandate </option>
	</select>
<div id='input_update_new_val'>
	
</div>
	<input type='submit' name='update_form_submit'><br>
</form>
<br><br><br>
Delete: <form action='' method='POST'>
	<select name='delete_select' onchange='select_input_delete(event)'>
		<option disabled selected> Delete by </option>
		<option value='staffID'> staffID </option>
		<option value='role'> role </option>
		<option value='mandate'> mandate </option>
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
			case 'staffID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_staffID'  type='number'  required><br>";
			break;
			case 'role':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_role'  type='text' maxlength='1024'  required><br>";
			break;
			case 'mandate':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_mandate'  type='text' maxlength='1024'  required><br>";
			break;
		}
	}
	function select_input_update_new(e) {
		switch(e.target.value) {
			case 'staffID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_staffID'  type='number'  required><br>";
			break;
			case 'role':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_role'  type='text' maxlength='1024'  required><br>";
			break;
			case 'mandate':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_mandate'  type='text' maxlength='1024'  required><br>";
			break;
		}
	}
	function select_input_update_cond(e) {
		switch(e.target.value) {
			case 'staffID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_staffID'  type='number'  required><br>";
			break;
			case 'role':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_role'  type='text' maxlength='1024'  required><br>";
			break;
			case 'mandate':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_mandate'  type='text' maxlength='1024'  required><br>";
			break;
		}
	}
</script>
</body></html>