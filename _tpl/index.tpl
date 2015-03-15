<?php
	if (isOk('author')) {
		$author = $_POST['author'];
		$_SESSION['authorSlug'] = slug($_POST['author']);
	}
