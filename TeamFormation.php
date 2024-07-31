<html><head><title>Team</title></head><body><?php
$s = 'localhost';
$u = 'php';
$p = 'php';
$d = 'php_db';
$conn = new mysqli($s, $u, $p, $d);
if ($conn->connect_error) {
	die('Connection failed: ' . $conn->connect_error);
}
$select_statement = 'SELECT * FROM Team';
$insert_statement = $conn->prepare('INSERT INTO Team(teamType,teamCoachID,teamLocation) VALUES (?,?,?)');
$insert_statement->bind_param('sii', $_POST['teamType'],$_POST['teamCoachID'],$_POST['teamLocation']);
if(isset($_POST['insert_form_submit'])) {
	$insert_statement->execute();	$insert_statement->close();	header('Refresh:0');

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
	if(!$conn->query("DELETE FROM Team WHERE ".$_POST['delete_select']." = ".$type."")) {
		die('huh????');
	}
	header('Refresh:0');

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
$conn->query("UPDATE Team SET ".$_POST['update_select_new_val']." = ".$a." WHERE ".$_POST['update_select_condition']." = ".$b."");
	header('Refresh:0');

}

?>
<form action='' method='POST'>
	teamType:<input name='teamType'  type='text' maxlength='5'  required><br>
	teamCoachID:<input name='teamCoachID'  type='number'  required><br>
	teamLocation:<input name='teamLocation'  type='number'  required><br>
	<input type='submit' name='insert_form_submit'><br>
</form>
<br><br><br>
Update: <form action='' method='POST'>
	<select name='update_select_condition' onchange='select_input_update_cond(event)'>
		<option disabled selected> Update condition </option>
		<option value='teamID'> teamID </option>
		<option value='teamType'> teamType </option>
		<option value='teamCoachID'> teamCoachID </option>
		<option value='teamLocation'> teamLocation </option>
	</select>
<div id='input_update_condition'>
	
</div>
	<select name='update_select_new_val' onchange='select_input_update_new(event)'>
		<option disabled selected> Update condition </option>
		<option value='teamID'> teamID </option>
		<option value='teamType'> teamType </option>
		<option value='teamCoachID'> teamCoachID </option>
		<option value='teamLocation'> teamLocation </option>
	</select>
<div id='input_update_new_val'>
	
</div>
	<input type='submit' name='update_form_submit'><br>
</form>
<br><br><br>
Delete: <form action='' method='POST'>
	<select name='delete_select' onchange='select_input_delete(event)'>
		<option disabled selected> Delete by </option>
		<option value='teamID'> teamID </option>
		<option value='teamType'> teamType </option>
		<option value='teamCoachID'> teamCoachID </option>
		<option value='teamLocation'> teamLocation </option>
	</select>
<div id='input_delete'>
	
</div>
	<input type='submit' name='delete_form_submit'><br>
</form>
<br><br><br>
<?php
$select_data = $conn->query($select_statement);
echo '<table>';
while ($row = $select_data->fetch_assoc()) {
	echo '<tr>';
	foreach($row as $d) {
		echo '<td>'.$d.'</td>';
	}
	echo '</tr>';
}
echo '</table>';
?>
<script>
	function select_input_delete(e) {
		switch(e.target.value) {
			case 'teamID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_teamID'  type='number'  required><br>";
			break;
			case 'teamType':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_teamType'  type='text' maxlength='5'  required><br>";
			break;
			case 'teamCoachID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_teamCoachID'  type='number'  required><br>";
			break;
			case 'teamLocation':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_teamLocation'  type='number'  required><br>";
			break;
		}
	}
	function select_input_update_new(e) {
		switch(e.target.value) {
			case 'teamID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_teamID'  type='number'  required><br>";
			break;
			case 'teamType':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_teamType'  type='text' maxlength='5'  required><br>";
			break;
			case 'teamCoachID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_teamCoachID'  type='number'  required><br>";
			break;
			case 'teamLocation':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_teamLocation'  type='number'  required><br>";
			break;
		}
	}
	function select_input_update_cond(e) {
		switch(e.target.value) {
			case 'teamID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_teamID'  type='number'  required><br>";
			break;
			case 'teamType':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_teamType'  type='text' maxlength='5'  required><br>";
			break;
			case 'teamCoachID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_teamCoachID'  type='number'  required><br>";
			break;
			case 'teamLocation':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_teamLocation'  type='number'  required><br>";
			break;
		}
	}
</script>
</body></html>