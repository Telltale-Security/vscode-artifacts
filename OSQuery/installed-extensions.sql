SELECT
  u.username,
  u.uuid AS user_sid,
  u.directory AS profile_path,
  lower(v.name) AS extension_id,
  v.version,
  v.publisher,
  v.path,
  CASE
    WHEN v.installed_at > 0
    THEN datetime(v.installed_at / 1000, 'unixepoch')
  END AS installed_at_utc,
  v.prerelease,
  v.vscode_edition
FROM users AS u
CROSS JOIN vscode_extensions AS v USING (uid)
WHERE v.name != ''
ORDER BY u.username, v.name;
