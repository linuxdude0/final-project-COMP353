<html><head><style>table, th, td {border:1px solid black;}</style><title>Users</title></head><body><?php
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
$select_statement = 'SELECT * FROM Users';
$insert_statement = $conn->prepare('INSERT INTO Users(firstName,lastName,gender,dateOfBirth,SSN,medicare,address,postalCode,province,city,phone,email) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)');
$insert_statement->bind_param('ssssssssssss', $_POST['firstName'],$_POST['lastName'],$_POST['gender'],$_POST['dateOfBirth'],$_POST['SSN'],$_POST['medicare'],$_POST['address'],$_POST['postalCode'],$_POST['province'],$_POST['city'],$_POST['phone'],$_POST['email']);
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
		if(!$conn->query("DELETE FROM Users WHERE ".$_POST['delete_select']." = ".$type."")) {
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
	$conn->query("UPDATE Users SET ".$_POST['update_select_new_val']." = ".$a." WHERE ".$_POST['update_select_condition']." = ".$b."");
	header('Refresh:0');

	} catch (Exception $e) {

		echo "Wrong manipulation of db: ".$e->getMessage()."<br><br>";

	}

}

?>
<form action='' method='POST'>
	firstName:<input name='firstName'  type='text' maxlength='1024'  ><br>
	lastName:<input name='lastName'  type='text' maxlength='1024'  ><br>
	gender:<input name='gender'  type='text' maxlength='1'  minlength='1'  required><br>
	dateOfBirth:<input name='dateOfBirth'  type='date'  ><br>
	SSN:<input name='SSN'  type='text' maxlength='9'  minlength='9'  ><br>
	medicare:<input name='medicare'  type='text' maxlength='12'  minlength='12'  ><br>
	address:<input name='address'  type='text' maxlength='1024'  ><br>
	postalCode:<input name='postalCode'  type='text' maxlength='6'  minlength='6'  ><br>
	province:<input name='province'  type='text' maxlength='2'  minlength='2'  ><br>
	city:<input name='city'  type='text' maxlength='1024'  ><br>
	phone:<input name='phone'  type='text' maxlength='15'  ><br>
	email:<input name='email'  type='text' maxlength='256'  ><br>
	<input type='submit' name='insert_form_submit'><br>
</form>
<br><br><br>
Update: <form action='' method='POST'>
	<select name='update_select_condition' onchange='select_input_update_cond(event)'>
		<option disabled selected> Update condition </option>
		<option value='userID'> userID </option>
		<option value='firstName'> firstName </option>
		<option value='lastName'> lastName </option>
		<option value='gender'> gender </option>
		<option value='dateOfBirth'> dateOfBirth </option>
		<option value='SSN'> SSN </option>
		<option value='medicare'> medicare </option>
		<option value='address'> address </option>
		<option value='postalCode'> postalCode </option>
		<option value='province'> province </option>
		<option value='city'> city </option>
		<option value='phone'> phone </option>
		<option value='email'> email </option>
	</select>
<div id='input_update_condition'>
	
</div>
	<select name='update_select_new_val' onchange='select_input_update_new(event)'>
		<option disabled selected> Update new value </option>
		<option value='userID'> userID </option>
		<option value='firstName'> firstName </option>
		<option value='lastName'> lastName </option>
		<option value='gender'> gender </option>
		<option value='dateOfBirth'> dateOfBirth </option>
		<option value='SSN'> SSN </option>
		<option value='medicare'> medicare </option>
		<option value='address'> address </option>
		<option value='postalCode'> postalCode </option>
		<option value='province'> province </option>
		<option value='city'> city </option>
		<option value='phone'> phone </option>
		<option value='email'> email </option>
	</select>
<div id='input_update_new_val'>
	
</div>
	<input type='submit' name='update_form_submit'><br>
</form>
<br><br><br>
Delete: <form action='' method='POST'>
	<select name='delete_select' onchange='select_input_delete(event)'>
		<option disabled selected> Delete by </option>
		<option value='userID'> userID </option>
		<option value='firstName'> firstName </option>
		<option value='lastName'> lastName </option>
		<option value='gender'> gender </option>
		<option value='dateOfBirth'> dateOfBirth </option>
		<option value='SSN'> SSN </option>
		<option value='medicare'> medicare </option>
		<option value='address'> address </option>
		<option value='postalCode'> postalCode </option>
		<option value='province'> province </option>
		<option value='city'> city </option>
		<option value='phone'> phone </option>
		<option value='email'> email </option>
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
			case 'userID':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_userID'  type='number'  required><br>";
			break;
			case 'firstName':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_firstName'  type='text' maxlength='1024'  required><br>";
			break;
			case 'lastName':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_lastName'  type='text' maxlength='1024'  required><br>";
			break;
			case 'gender':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_gender'  type='text' maxlength='1'  minlength='1'  required><br>";
			break;
			case 'dateOfBirth':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_dateOfBirth'  type='date'  required><br>";
			break;
			case 'SSN':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_SSN'  type='text' maxlength='9'  minlength='9'  required><br>";
			break;
			case 'medicare':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_medicare'  type='text' maxlength='12'  minlength='12'  required><br>";
			break;
			case 'address':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'postalCode':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_postalCode'  type='text' maxlength='6'  minlength='6'  required><br>";
			break;
			case 'province':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_province'  type='text' maxlength='2'  minlength='2'  required><br>";
			break;
			case 'city':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_city'  type='text' maxlength='1024'  required><br>";
			break;
			case 'phone':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_phone'  type='text' maxlength='15'  required><br>";
			break;
			case 'email':
				document.getElementById('input_delete').innerHTML = 
					"<input name='delete_email'  type='text' maxlength='256'  required><br>";
			break;
		}
	}
	function select_input_update_new(e) {
		switch(e.target.value) {
			case 'userID':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_userID'  type='number'  required><br>";
			break;
			case 'firstName':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_firstName'  type='text' maxlength='1024'  required><br>";
			break;
			case 'lastName':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_lastName'  type='text' maxlength='1024'  required><br>";
			break;
			case 'gender':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_gender'  type='text' maxlength='1'  minlength='1'  required><br>";
			break;
			case 'dateOfBirth':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_dateOfBirth'  type='date'  required><br>";
			break;
			case 'SSN':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_SSN'  type='text' maxlength='9'  minlength='9'  required><br>";
			break;
			case 'medicare':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_medicare'  type='text' maxlength='12'  minlength='12'  required><br>";
			break;
			case 'address':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'postalCode':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_postalCode'  type='text' maxlength='6'  minlength='6'  required><br>";
			break;
			case 'province':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_province'  type='text' maxlength='2'  minlength='2'  required><br>";
			break;
			case 'city':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_city'  type='text' maxlength='1024'  required><br>";
			break;
			case 'phone':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_phone'  type='text' maxlength='15'  required><br>";
			break;
			case 'email':
				document.getElementById('input_update_new_val').innerHTML = 
					"<input name='update_new_val_email'  type='text' maxlength='256'  required><br>";
			break;
		}
	}
	function select_input_update_cond(e) {
		switch(e.target.value) {
			case 'userID':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_userID'  type='number'  required><br>";
			break;
			case 'firstName':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_firstName'  type='text' maxlength='1024'  required><br>";
			break;
			case 'lastName':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_lastName'  type='text' maxlength='1024'  required><br>";
			break;
			case 'gender':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_gender'  type='text' maxlength='1'  minlength='1'  required><br>";
			break;
			case 'dateOfBirth':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_dateOfBirth'  type='date'  required><br>";
			break;
			case 'SSN':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_SSN'  type='text' maxlength='9'  minlength='9'  required><br>";
			break;
			case 'medicare':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_medicare'  type='text' maxlength='12'  minlength='12'  required><br>";
			break;
			case 'address':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_address'  type='text' maxlength='1024'  required><br>";
			break;
			case 'postalCode':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_postalCode'  type='text' maxlength='6'  minlength='6'  required><br>";
			break;
			case 'province':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_province'  type='text' maxlength='2'  minlength='2'  required><br>";
			break;
			case 'city':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_city'  type='text' maxlength='1024'  required><br>";
			break;
			case 'phone':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_phone'  type='text' maxlength='15'  required><br>";
			break;
			case 'email':
				document.getElementById('input_update_condition').innerHTML = 
					"<input name='update_condition_email'  type='text' maxlength='256'  required><br>";
			break;
		}
	}
</script>
</body></html>