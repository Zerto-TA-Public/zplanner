<?php
function redirect($url, $permanent = false)
{
    header('Location: ' . $url, true, $permanent ? 301 : 302);

    exit();
}
$full_url = "http://$_SERVER[HTTP_HOST]".":3000";
redirect($full_url, false);
?>
