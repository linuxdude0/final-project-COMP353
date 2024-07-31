<html>
	<head>
	<title>email</title>
	</head>
	<body>
		<?php
		$server="127.0.0.1";
		$username="php";
		$password="php";
		$db="php_db";
		$conn = new mysqli($server, $username, $password, $db);
		if ($conn->connect_error) {
			die($conn->connect_error);
		}
		$today = date('Y-m-d');
		$result = $conn->query("SELECT * FROM Email WHERE date='".$today."'");
		$is_sent = $result->num_rows > 0;
		function send_mail() {
			$insert_stored = mysqli->prepare("INSERT INTO Email (
				date,
				sender_email,
				dest_email,
				email_title,
				email_body,
			) VALUES (?,?,?,?,?)");
			$email_date = $today;
			$dest_email = '';
			$email_title = '';
			$email_body = '';
			$insert_stored->bind_params("ssss", $email_date, $dest_email, $email_title, $email_body);
			$mysqli->multi_query("CALL EmailInfo('".$today."')");
			do {
				if ($result = $mysqli->store_result()) {
					foreach($result->fetch_all() as $club_member) {
						$dest_email = $club_member['email'];
						$email_body = substr("first_name: '".$club_member['first_name']."'\nlast_name: '".$club_member['last_name']."'\nRole: '".$club_member['role']."'\nCoach first name: '".$club_member['coach_first_name']."'\nCoach last name: '".$club_member['coach_last_name']."'\nCoach email: '".$club_member['coach_email']."'\nSession type: '".$club_member['session_type']."'\nSession Address: '".$club_member['session_address']."'\n", 0, 100);
						$email_title = $club_member['location_name']." ".$club_member['teamID']." ".$club_member['session_time']." ".$club_member['session_type']." session";
						$insert_stored->execute();
					}
					$result->free();
				}
			} while ($mysqli->next_result());
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
		if (date('w') == 0 && !$is_sent) {
			send_mail();
		}
		echo "<a href='./index.php'>Home</a>";
		echo "<h1>Email</h1>";
		print_table($conn->query('SELECT * FROM Email'));
		$conn->close();
		?>
	</body>
</html>
