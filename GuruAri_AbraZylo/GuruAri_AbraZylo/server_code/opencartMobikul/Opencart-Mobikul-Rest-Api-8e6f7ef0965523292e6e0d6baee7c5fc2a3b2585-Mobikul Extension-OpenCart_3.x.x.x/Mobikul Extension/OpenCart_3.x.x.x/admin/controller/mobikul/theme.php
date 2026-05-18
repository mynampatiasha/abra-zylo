<?php
class ControllerMobikulTheme extends Controller
{
    private $error = array();

    public function index()
    {

        $data = array();

        $this->language->load('mobikul/theme');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('tool/image');

        if (($this->request->server['REQUEST_METHOD'] == 'POST')) {

            $theme__image_array = array(
                'bright_splash',
                'dark_splash',
                'bright_logo',
                'dark_logo',
            );

            foreach ($theme__image_array as $value) {

                if (isset($_FILES['mobikul_theme_' . $value]) && !$_FILES['mobikul_theme_' . $value]['error']) {
                    $uploaddir = DIR_IMAGE . 'mobikul/' . $value . '/';
                    $uploadfile = $uploaddir . basename($_FILES['mobikul_theme_' . $value]['name']);

                    if (!file_exists($uploaddir)) {
                        mkdir($uploaddir);
                    } else {
                        unlink(str_replace(HTTPS_CATALOG . 'image/', DIR_IMAGE, $this->config->get('mobikul_theme_' . $value)));
                    }
                    if (move_uploaded_file($_FILES['mobikul_theme_' . $value]['tmp_name'], $uploadfile)) {
                        $uploadfile = str_replace(DIR_IMAGE, HTTPS_CATALOG . 'image/', $uploadfile);
                        $this->request->post['mobikul_theme_' . $value] = $uploadfile;
                    }
                } else {
                    $this->request->post['mobikul_theme_' . $value] = $this->config->get('mobikul_theme_' . $value);
                }
            }

            $this->load->model('setting/setting');

            $this->model_setting_setting->editSetting('mobikul_theme', $this->request->post);

            $this->session->data['success'] = $this->language->get('text_success');

            $this->response->redirect($this->url->link('mobikul/theme', 'user_token=' . $this->session->data['user_token'], 'SSL'));

        }

        if (isset($this->error['warning'])) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }

        if (isset($this->error['image'])) {
            $data['error_image'] = $this->error['image'];
        } else {
            $data['error_image'] = array();
        }

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], 'SSL'),
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('mobikul/theme', 'user_token=' . $this->session->data['user_token'], 'SSL'),
        );

        $data['action'] = $this->url->link('mobikul/theme', 'user_token=' . $this->session->data['user_token'], 'SSL');

        $default_array = array(
            'mobikul_theme_bright_app_button_color' => '#000000',
            'mobikul_theme_bright_app_button_text_theme_color' => '#ffffff',
            'mobikul_theme_bright_app_theme_color' => '#546E7A',
            'mobikul_theme_bright_theme_text_color' => '#ffffff',
            'mobikul_theme_bright_background_color' => '#ffffff',
            'mobikul_theme_bright_splash' => '',
            'mobikul_theme_bright_logo' => '',
            'mobikul_theme_dark_app_button_color' => '#ffffff',
            'mobikul_theme_dark_app_button_text_theme_color' => '#000000',
            'mobikul_theme_dark_app_theme_color' => '#000000',
            'mobikul_theme_dark_theme_text_color' => '#ffffff',
            'mobikul_theme_dark_background_color' => '#000000',
            'mobikul_theme_dark_splash' => '',
            'mobikul_theme_dark_logo' => '',
        );

        $data_array = array(
            'mobikul_theme_bright_app_button_color',
            'mobikul_theme_bright_app_button_text_theme_color',
            'mobikul_theme_bright_app_theme_color',
            'mobikul_theme_bright_theme_text_color',
            'mobikul_theme_bright_background_color',
            'mobikul_theme_bright_splash',
            'mobikul_theme_bright_logo',
            'mobikul_theme_dark_app_button_color',
            'mobikul_theme_dark_app_button_text_theme_color',
            'mobikul_theme_dark_app_theme_color',
            'mobikul_theme_dark_theme_text_color',
            'mobikul_theme_dark_background_color',
            'mobikul_theme_dark_splash',
            'mobikul_theme_dark_logo',
        );

        foreach ($data_array as $value) {
            if (isset($this->request->post[$value])) {
                $data[$value] = $this->request->post[$value];
            } else if ($this->config->get($value)) {
                $data[$value] = $this->config->get($value);
            } else {
                $data[$value] = $default_array[$value];
            }
        }

        $data['user_token'] = $this->session->data['user_token'];

        if (isset($this->session->data['success'])) {
            $data['success'] = $this->session->data['success'];

            unset($this->session->data['success']);
        } else {
            $data['success'] = '';
        }

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('mobikul/theme', $data));
    }
    public function resetThemeColor()
    {

        $json = array();

        if (isset($this->request->get['reset'])) {

            $default_color_array = array(
                'mobikul_theme_bright_app_button_color' => '#000000',
                'mobikul_theme_bright_app_button_text_theme_color' => '#ffffff',
                'mobikul_theme_bright_app_theme_color' => '#546E7A',
                'mobikul_theme_bright_theme_text_color' => '#ffffff',
                'mobikul_theme_bright_background_color' => '#ffffff',

                'mobikul_theme_dark_app_button_color' => '#ffffff',
                'mobikul_theme_dark_app_button_text_theme_color' => '#000000',
                'mobikul_theme_dark_app_theme_color' => '#000000',
                'mobikul_theme_dark_theme_text_color' => '#ffffff',
                'mobikul_theme_dark_background_color' => '#000000',
            );

            $key_array = array(
                'app_button_color',
                'app_button_text_theme_color',
                'app_theme_color',
                'theme_text_color',
                'background_color',

            );

            $json['success'] = true;

            if ($this->request->get['reset'] == 'reset_bright_color') {
                $reset_theme = 'mobikul_theme_bright_';
            } else {
                $reset_theme = 'mobikul_theme_dark_';
            }

            $this->load->model('setting/setting');

            foreach ($key_array as $key) {

                $this->model_setting_setting->editSettingValue('mobikul_theme', $reset_theme . $key, $default_color_array[$reset_theme . $key]);
                $json['color'][$reset_theme . $key] = $default_color_array[$reset_theme . $key];

            }

        }

        $this->response->addHeader('Content-Type:application/json');
        $this->response->setOutput(json_encode($json));

    }

}
