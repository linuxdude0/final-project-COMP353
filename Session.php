<html><head><style>table, th, td {border:1px solid black;}</style><title>Session</title></head><body><?php
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
$select_statement = 'SELECT * FROM Session';
$insert_statement = $conn->prepare('INSERT INTO Session(teamOneID,teamTwoID,time,scoreOne,scoreTwo,address,type) VALUES (?,?,?,?,?,?,?)');
$insert_statement->bind_param('iisiiss', $_POST['teamOneID'],$_POST['teamTwoID'],$_POST['time'],$_POST['scoreOne'],$_POST['scoreTwo'],$_POST['address'],$_POST['type']);
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
		if(!$conn->query("DELETE FROM Session WHERE ".$_POST['delete_select']." = ".$type."")) {
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
	$conn->query("UPDATE Session SET ".$_POST['update_select_new_val']." = ".$a." WHERE ".$_POST['update_select_condition']." = ".$b."");
	header('Refresh:0');

	} catch (Exception $e) {

		echo "Wrong manipulation of db: ".$e->getMessage()."<br><br>";

	}

}

?>
<form action='' method='POST'>
	teamOneID:<input name='teamOneID'  type='number'  required><br>
	teamTwoID:<input name='teamTwoID'  type='number'  required><br>
	time:<input name='time'  type='text' maxlength=''  required><br>
	scoreOne:<input name='scoreOne'  type='number'  ><br>
	scoreTwo:<input name='scoreTwo'  type='number'  ><br>
	address:<input name='address'  type='text' maxlength='1024'  ><br>
	type:<input name='type'  type='text' maxlength='16'  ><br>
	<input type='submit' name='insert_form_submit'><br>
</form>
<br><br><br>
Update: <form action='' method='POST'>
	<select name='update_select_condition' onchange='select_input_update_cond(event)'>
		<option disabled selected> Update condition </option>
		<option value='teamOneID'> teamOneID </option>
		<option value='teamTwoID'> teamTwoID </option>
		<option value='time'> time </option>
		<option value='scoreOne'> scoreOne </option>
		<option value='scoreTwo'> scoreTwo </option>
		<option value='address'> address </option>
		<option value='type'> type </option>
	</select>
<div id='input_update_condition'>
	
</div>
	<select name='update_select_new_val' onchange='select_input_update_new(event)'>
		<option disabled selected> Update new value </option>
		<option value='teamOneID'> teamOneID </option>
		<option value='teamTwoID'> teamTwoID </option>
		<option value='time'> time </option>
		<option value='scoreOne'> scoreOne </option>
		<option value='scoreTwo'> scoreTwo </option>
		<option value='address'> address </option>
		<option value='type'> type </option>
	</select>
<div id='input_update_new_val'>
	
</div>
	<input type='submit' name='update_form_submit'><br>
</form>
<br><br><br>
Delete: <form action='' method='POST'>
	<select name='delete_select' onchange='select_input_delete(event)'>
		<option disabled selected> Delete by </option>
		<option value='teamOneID'> teamOneID </option>
		<option value='teamTwoID'> teamTwoID </option>
		<option value='time'> time </option>
		<option value='scoreOne'> scoreOne </option>
		<option value='scoreTwo'> scoreTwo </option>
		<option value='address'> address </option>
		<option value='type'> type </option>
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
			case 'teamOneID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_teamOneID'  type='number'  required><br>";
			break;
			case 'teamTwoID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_teamTwoID'  type='number'  required><br>";
			break;
			case 'time':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_time'  type='text' maxlength=''  required><br>";
			break;
			case 'scoreOne':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_scoreOne'  type='number'  required><br>";
			break;
			case 'scoreTwo':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_scoreTwo'  type='number'  required><br>";
			break;
			case 'address':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'type':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_type'  type='text' maxlength='16'  required><br>";
			break;
		}
	}
	function select_input_update_new(e) {
		switch(e.target.value) {
			case 'teamOneID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_teamOneID'  type='number'  required><br>";
			break;
			case 'teamTwoID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_teamTwoID'  type='number'  required><br>";
			break;
			case 'time':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_time'  type='text' maxlength=''  required><br>";
			break;
			case 'scoreOne':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_scoreOne'  type='number'  required><br>";
			break;
			case 'scoreTwo':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_scoreTwo'  type='number'  required><br>";
			break;
			case 'address':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'type':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_type'  type='text' maxlength='16'  required><br>";
			break;
		}
	}
	function select_input_update_cond(e) {
		switch(e.target.value) {
			case 'teamOneID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_teamOneID'  type='number'  required><br>";
			break;
			case 'teamTwoID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_teamTwoID'  type='number'  required><br>";
			break;
			case 'time':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_time'  type='text' maxlength=''  required><br>";
			break;
			case 'scoreOne':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_scoreOne'  type='number'  required><br>";
			break;
			case 'scoreTwo':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_scoreTwo'  type='number'  required><br>";
			break;
			case 'address':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'type':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_type'  type='text' maxlength='16'  required><br>";
			break;
		}
	}
</script>
</body></html>