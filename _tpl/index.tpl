<?php
	if (isOk('author')) {
		$author = $_POST['author'];
		$_SESSION['authorSlug'] = slug($_POST['author']);
	}
			// Check if slug is available
			$sql = 'SELECT * FROM pages WHERE slug = "' . $db->real_escape_string($_POST['slug']) . '"';
			$result = $db->query($sql);
			if (in_array($_POST['slug'], $reservedSlugs) || 0 !== $result->num_rows) {
				$slugError = '<span class="error">This slug is already in use. Please choose another one.</span>';
			} else {

				// Slug is available, go ahead and add the test case
				$browserscopeID = addBrowserscopeTest($_POST['title'], $_POST['info'], 'http://' . DOMAIN . '/' . $_POST['slug']);

				$sql = 'INSERT INTO pages (slug, browserscopeID, title, info, initHTML, setup, teardown, published, author, authorEmail, authorURL, visible) VALUES ("' . $db->real_escape_string($_POST['slug']) . '", ' . ($browserscopeID ? '"' . $db->real_escape_string($browserscopeID) . '"' : 'NULL') . ', "' . $db->real_escape_string($_POST['title']) . '", "' . $db->real_escape_string($_POST['info']) . '", "' . $db->real_escape_string($_POST['prep-html']) . '", "' . $db->real_escape_string($_POST['setup']) . '", "' . $db->real_escape_string($_POST['teardown']) . '", NOW(), "' . $db->real_escape_string($_POST['author']) . '", "' . $db->real_escape_string($_POST['author-email']) . '", "' . $db->real_escape_string($_POST['author-url']) . '", "' . $visible . '")';
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
