<html><head><title>Location</title></head><body><?php
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
$select_statement = 'SELECT * FROM Location';
$insert_statement = $conn->prepare('INSERT INTO Location(location_name,address,city,postalCode,province,tel,website,type,capacity) VALUES (?,?,?,?,?,?,?,?,?)');
$insert_statement->bind_param('ssssssssi', $_POST['location_name'],$_POST['address'],$_POST['city'],$_POST['postalCode'],$_POST['province'],$_POST['tel'],$_POST['website'],$_POST['type'],$_POST['capacity']);
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
		if(!$conn->query("DELETE FROM Location WHERE ".$_POST['delete_select']." = ".$type."")) {
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
	$conn->query("UPDATE Location SET ".$_POST['update_select_new_val']." = ".$a." WHERE ".$_POST['update_select_condition']." = ".$b."");
	header('Refresh:0');

	} catch (Exception $e) {

		echo "Wrong manipulation of db: ".$e->getMessage()."<br><br>";

	}

}

?>
<form action='' method='POST'>
	location_name:<input name='location_name'  type='text' maxlength='128'  ><br>
	address:<input name='address'  type='text' maxlength='1024'  required><br>
	city:<input name='city'  type='text' maxlength='1024'  required><br>
	postalCode:<input name='postalCode'  type='text' maxlength='6'  minlength='6'  ><br>
	province:<input name='province'  type='text' maxlength='2'  minlength='2'  ><br>
	tel:<input name='tel'  type='text' maxlength='15'  ><br>
	website:<input name='website'  type='text' maxlength='1024'  ><br>
	type:<input name='type'  type='text' maxlength='1024'  required><br>
	capacity:<input name='capacity'  type='number'  ><br>
	<input type='submit' name='insert_form_submit'><br>
</form>
<br><br><br>
Update: <form action='' method='POST'>
	<select name='update_select_condition' onchange='select_input_update_cond(event)'>
		<option disabled selected> Update condition </option>
		<option value='locID'> locID </option>
		<option value='location_name'> location_name </option>
		<option value='address'> address </option>
		<option value='city'> city </option>
		<option value='postalCode'> postalCode </option>
		<option value='province'> province </option>
		<option value='tel'> tel </option>
		<option value='website'> website </option>
		<option value='type'> type </option>
		<option value='capacity'> capacity </option>
	</select>
<div id='input_update_condition'>
	
</div>
	<select name='update_select_new_val' onchange='select_input_update_new(event)'>
		<option disabled selected> Update new value </option>
		<option value='locID'> locID </option>
		<option value='location_name'> location_name </option>
		<option value='address'> address </option>
		<option value='city'> city </option>
		<option value='postalCode'> postalCode </option>
		<option value='province'> province </option>
		<option value='tel'> tel </option>
		<option value='website'> website </option>
		<option value='type'> type </option>
		<option value='capacity'> capacity </option>
	</select>
<div id='input_update_new_val'>
	
</div>
	<input type='submit' name='update_form_submit'><br>
</form>
<br><br><br>
Delete: <form action='' method='POST'>
	<select name='delete_select' onchange='select_input_delete(event)'>
		<option disabled selected> Delete by </option>
		<option value='locID'> locID </option>
		<option value='location_name'> location_name </option>
		<option value='address'> address </option>
		<option value='city'> city </option>
		<option value='postalCode'> postalCode </option>
		<option value='province'> province </option>
		<option value='tel'> tel </option>
		<option value='website'> website </option>
		<option value='type'> type </option>
		<option value='capacity'> capacity </option>
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
			case 'locID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_locID'  type='number'  required><br>";
			break;
			case 'location_name':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_location_name'  type='text' maxlength='128'  required><br>";
			break;
			case 'address':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'city':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_city'  type='text' maxlength='1024'  required><br>";
			break;
			case 'postalCode':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_postalCode'  type='text' maxlength='6'  minlength='6'  required><br>";
			break;
			case 'province':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_province'  type='text' maxlength='2'  minlength='2'  required><br>";
			break;
			case 'tel':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_tel'  type='text' maxlength='15'  required><br>";
			break;
			case 'website':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_website'  type='text' maxlength='1024'  required><br>";
			break;
			case 'type':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_type'  type='text' maxlength='1024'  required><br>";
			break;
			case 'capacity':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_capacity'  type='number'  required><br>";
			break;
		}
	}
	function select_input_update_new(e) {
		switch(e.target.value) {
			case 'locID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_locID'  type='number'  required><br>";
			break;
			case 'location_name':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_location_name'  type='text' maxlength='128'  required><br>";
			break;
			case 'address':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'city':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_city'  type='text' maxlength='1024'  required><br>";
			break;
			case 'postalCode':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_postalCode'  type='text' maxlength='6'  minlength='6'  required><br>";
			break;
			case 'province':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_province'  type='text' maxlength='2'  minlength='2'  required><br>";
			break;
			case 'tel':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_tel'  type='text' maxlength='15'  required><br>";
			break;
			case 'website':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_website'  type='text' maxlength='1024'  required><br>";
			break;
			case 'type':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_type'  type='text' maxlength='1024'  required><br>";
			break;
			case 'capacity':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_capacity'  type='number'  required><br>";
			break;
		}
	}
	function select_input_update_cond(e) {
		switch(e.target.value) {
			case 'locID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_locID'  type='number'  required><br>";
			break;
			case 'location_name':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_location_name'  type='text' maxlength='128'  required><br>";
			break;
			case 'address':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'city':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_city'  type='text' maxlength='1024'  required><br>";
			break;
			case 'postalCode':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_postalCode'  type='text' maxlength='6'  minlength='6'  required><br>";
			break;
			case 'province':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_province'  type='text' maxlength='2'  minlength='2'  required><br>";
			break;
			case 'tel':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_tel'  type='text' maxlength='15'  required><br>";
			break;
			case 'website':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_website'  type='text' maxlength='1024'  required><br>";
			break;
			case 'type':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_type'  type='text' maxlength='1024'  required><br>";
			break;
			case 'capacity':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_capacity'  type='number'  required><br>";
			break;
		}
	}
</script>
</body></html>