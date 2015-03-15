<?php
	if (isOk('author')) {
		$author = $_POST['author'];
		$_SESSION['authorSlug'] = slug($_POST['author']);
	}

				if ($db->query($sql)) {
					// Now add the tests to the test case
					$pageID = $db->insert_id;
					$sql = 'INSERT INTO tests (pageID, title, defer, code) VALUES';
					foreach ($_POST['test'] as $test) {
						$test['defer'] = isset($test['defer']) && ('y' == $test['defer']) ? 'y' : 'n';
						if (!empty($test['title']) && !empty($test['code'])) {
							$sql .= ' (' . $pageID . ', "' . $db->real_escape_string($test['title']) . '", "' . $test['defer'] . '", "' . $db->real_escape_string($test['code']) . '"), ';
						}
					}
					$sql = trim($sql, ', ');
					if ($db->query($sql)) {
						// Tests were added; redirect to new test case
						$_SESSION['own'][$pageID] = true;
						header('Location: http://' . DOMAIN . '/' . $_POST['slug']);
					} else {
						@mail(ADMIN_EMAIL, '[jsPerf] Failed to add tests to testcase: ' . $_POST['title'], 'http://' . DOMAIN . '/' . $_POST['slug'] . "\n" . var_export($_POST, true));
					}
				}
			}
