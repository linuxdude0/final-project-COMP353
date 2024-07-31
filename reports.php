<html>
	<head>
		<title>Reports</title>
	</head>
	<body>
<?php
echo "<a href='./index.php'>home</a>";
$mysqli = new mysqli('localhost', 'php', 'php', 'php_db');
if ($mysqli->connect_error) {
	die($mysqli->connect_error);
}
function print_table($result) {
	if ($result->num_rows > 0) {
	echo "<table>";
	$i = $result->fetch_all(MYSQLI_ASSOC);
	$curr = $i[0];
	echo "<tr>";
	foreach($curr as $k => $v) {
		echo "<th>".$k."</th>";
	}
	echo "</tr>";
	for($l = 0;$l<count($i);$l++) {
		echo "<tr>";
		foreach($i[$l] as $j) {
			echo "<td>".$j."</td>";
		}
		echo "</tr>";
	}
	$result->free();
		echo "</table>";
		} else {
			echo "Empty Set";
		}
}
echo "<h1> Q7</h1>";
$mysqli->multi_query("CALL all_location()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());

echo "<h1> Q8</h1>";
echo "<form action='' method='POST'>";
echo "famID:<input type='number' name='q8_famID' required>";
echo "<input type='submit' name='q8_submit'>";
echo "</form>";
if(isset($_POST['q8_submit'])) {
$mysqli->multi_query("CALL Q8(".$_POST['q8_famID'].")");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
}
echo "<br><br>";

echo "<h1> Q9</h1>";
echo "<form action='' method='POST'>";
echo "locID:<input type='number' name='q9_locID' required><br>";
echo "date:<input type='date' name='q9_date' required>";
echo "<input type='submit' name='q9_submit'>";
echo "</form>";
if(isset($_POST['q9_submit'])) {
$mysqli->multi_query("CALL Q9(".$_POST['q9_locID'].",'".$_POST['q9_date']."')");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
}

echo "<br><br>";
echo "<h1> Q10</h1>";
$mysqli->multi_query("CALL Q10()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
echo "<br><br>";

echo "<h1> Q11</h1>";
echo "<form action='' method='POST'>";
echo "date1:<input type='date' name='q11_date1' required><br>";
echo "date2:<input type='date' name='q11_date2' required><br>";
echo "<input type='submit' name='q11_submit'>";
echo "</form>";
if(isset($_POST['q11_submit'])) {
$mysqli->multi_query("CALL Q11('".$_POST['q11_date1']."','".$_POST['q11_date2']."')");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
}
echo "<br><br>";


echo "<h1> Q12</h1>";
$mysqli->multi_query("CALL Q12()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
echo "<br><br>";

echo "<h1> Q13</h1>";
$mysqli->multi_query("CALL Q13()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
echo "<br><br>";

echo "<h1> Q14</h1>";
$mysqli->multi_query("CALL Q14()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
echo "<br><br>";

echo "<h1> Q15</h1>";
echo "<form action='' method='POST'>";
echo "locID:<input type='number' name='q15_locID' required><br>";
echo "<input type='submit' name='q15_submit'>";
echo "</form>";
if(isset($_POST['q15_submit'])) {
$mysqli->multi_query("CALL Q15(".$_POST['q15_locID'].")");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
}
echo "<br><br>";

echo "<h1> Q16</h1>";
$mysqli->multi_query("CALL Q16()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
echo "<br><br>";

echo "<h1> Q17</h1>";
$mysqli->multi_query("CALL Q17()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
echo "<br><br>";

echo "<h1> Q18</h1>";
$mysqli->multi_query("CALL Q18()");
do {
	if ($result = $mysqli->store_result()) {
		print_table($result);
    }
} while ($mysqli->next_result());
echo "<br><br>";
?>
	</body>
</html>
