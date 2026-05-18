<?php
class ControllerApiWkrestapiCatalog extends Controller
{

    public function getReviews()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $this->load->language('product/product');

            $this->load->model('catalog/review');

            if (!isset($post['page']) || !$post['page']) {
                $post['page'] = 1;
            }

            if (!isset($post['limit']) || !$post['limit']) {
                $post['limit'] = 5;
            }

            if (!isset($post['product_id']) || !$post['product_id']) {
                $post['product_id'] = 0;
            }

            $data['total'] = $this->model_catalog_review->getTotalReviewsByProductId($post['product_id']);

            $results = $this->model_catalog_review->getReviewsByProductId($post['product_id'], ($post['page'] - 1) * $post['limit'], $post['limit']);

            $data['error'] = 0;
            $data['reviews'] = array();

            foreach ($results as $result) {
                $data['reviews'][] = array(
                    'author' => html_entity_decode($result['author'], ENT_QUOTES, "UTF-8"),
                    'text' => htmlspecialchars_decode(nl2br($result['text'])),
                    'rating' => (int) $result['rating'],
                    'date_added' => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($data));
        }
    }

    public function arProduct()
    {

        if (isset($this->request->get['product_id'])) {
            $ar_info = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_ar WHERE product_id = '" . $this->request->get['product_id'] . "'")->row;

            if ($ar_info) {
                if (isset($_SERVER['HTTP_USER_AGENT']) && strpos(strtolower($_SERVER['HTTP_USER_AGENT']), 'ios')) {
                    $file = DIR_DOWNLOAD . "mobikul_ar/" . $ar_info['ios_file'];
                    $mask = basename($ar_info['ios_file']);
                } elseif (isset($_SERVER['HTTP_USER_AGENT']) && strpos(strtolower($_SERVER['HTTP_USER_AGENT']), 'android')) {
                    $file = DIR_DOWNLOAD . "mobikul_ar/" . $ar_info['android_file'];
                    $mask = basename($ar_info['android_file']);
                } else {
                    $file = '';
                    $mask = '';
                }

                if (!headers_sent()) {
                    if (file_exists($file)) {
                        header('Content-Type: application/octet-stream');
                        header('Content-Disposition: attachment; filename="' . ($mask ? $mask : basename($file)) . '"');
                        header('Expires: 0');
                        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
                        header('Pragma: public');
                        header('Content-Length: ' . filesize($file));

                        if (ob_get_level()) {
                            ob_end_clean();
                        }

                        readfile($file, 'rb');

                        exit();
                    } else {
                        exit('Error: Could not find file ' . $file . '!');
                    }
                }
            }
        }
    }

    /**
     * Fetches the category using category path
     * @param  json $data contains category data
     * @return json       return data of the category
     */
    public function productCategory()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $category_data = array();

            foreach ($post as $key => $value) {
                $category_data[$key] = $value;
            }

            if (isset($category_data['path'])) {
                $this->load->model('wkrestapi/catalog');

                $categoryData = $this->model_wkrestapi_catalog->productCategory($category_data);

                if ($categoryData) {
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($categoryData));
                } else {
                    $return_array = array(
                        'error' => 1,
                    );
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($return_array));
                }
            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_path_error'),
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }


    /**
     * Fetches info of a product using product ID
     * @param  json $data contains product ID and device's width
     * @return json       return product data
     */
    public function getProduct()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            if (isset($post['width'])) {
                $width = (int)$post['width'];
            } else {
                $width = 100;
            }

            if (isset($post['product_id'])) {
                $product_id = $post['product_id'];
            } else {
                $product_id = 0;
            }

            $this->load->model('wkrestapi/catalog');

            $productData = $this->model_wkrestapi_catalog->getProduct($product_id, $width);

            if ($this->config->get('config_stock_checkout')) {
                $out_of_stock_checkout = true;
            } else {
                $out_of_stock_checkout = false;
            }

            if (isset($productData) && !empty($productData)) {
                $productData = array_merge($productData, array('out_of_stock_checkout' => $out_of_stock_checkout));
            }

            if ($productData) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($productData));
            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_no_product'),
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Fetches special product
     * @return json       return product data
     */
    public function getSpecialProduct()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $return_array = array(
                'fault' => 1,
                'message' => $this->language->get('text_token_message'),
            );
        } else {

            if (isset($post['width'])) {
                $width = (int) $post['width'];
            } else {
                $width = 100;
            }

            $this->load->model('wkrestapi/catalog');

            $productData = $this->model_wkrestapi_catalog->getSpecialProduct($post, $width);

            if ($productData) {
                $return_array = $productData;
            } else {
                $return_array = array(
                    'error' => 1,
                );
            }
        }
        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($return_array));
    }

    /**
     * Writes product's review
     * @param  json $data contains review data
     * @return json       return error if exists
     */
    public function writeProductReview()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $review_data = array();

            foreach ($post as $key => $value) {
                $review_data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (isset($review_data['product_id']) && $review_data['product_id']) {

                $reviewStatus = $this->model_wkrestapi_catalog->writeProductReview($review_data);

                if ($reviewStatus) {
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($reviewStatus));
                } else {
                    $return_array = array(
                        'error' => 1,
                        'message' => $this->language->get('text_verify'),
                    );
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($return_array));
                }
            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_product_message'),
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * adds an item to wish list
     * @param json $data contains product data
     */
    public function addToWishlist()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $product_id = $post['product_id'];

            $this->load->model('wkrestapi/catalog');

            $addToWish = $this->model_wkrestapi_catalog->addToWishlist($product_id);

            if ($addToWish) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($addToWish));
            } else {
                $return_array = array(
                    'error' => 1,
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Searches a product using field
     * @param  json $data contains search data
     * @return json       returns searched data
     */
    public function productSearch()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $search_data = array();

            foreach ($post as $key => $value) {
                $search_data[$key] = $value;
            }

            if (!isset($search_data['width'])) {
                $search_data['width'] = 100;
            }

            $this->load->model('wkrestapi/catalog');

            $productSearch = $this->model_wkrestapi_catalog->productSearch($search_data);

            if ($productSearch) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($productSearch));
            } else {
                $return_array = array(
                    'error' => 1,
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Fetches the notifications of previous hour
     * @param  json $data contains customer data
     * @return json       returns notifications
     */
    public function getNotifications()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $this->load->model('wkrestapi/catalog');

            $notifications = $this->model_wkrestapi_catalog->getNotifications();

            if ($notifications) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($notifications));
            } else {
                $return_array = array(
                    'error' => 1,
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Fetches latest 20 notifications
     * @param  json $data contains customer data
     * @return json       returns notification data
     */
    public function viewNotifications()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $this->load->model('wkrestapi/catalog');

            if (!isset($post['width'])) {
                $post['width'] = 100;
            }

            $notifications = $this->model_wkrestapi_catalog->viewNotifications((int) $post['width']);

            if ($notifications) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($notifications));
            } else {
                $return_array = array(
                    'error' => 1,
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    public function customCollection()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            if (isset($post['id']) && $post['id']) {
                $this->load->model('wkrestapi/catalog');

                $return_array = $this->model_wkrestapi_catalog->customCollection($post);

                if (!$return_array) {
                    $return_array = array(
                        'error' => 1,
                    );
                }
            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_collection_message'),
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches the list of all the manufacturers
     * @param  json $data contains customer data
     * @return json       returns the manufacturers list
     */
    public function productManufacturer()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $this->load->model('wkrestapi/catalog');

            $manufacturers = $this->model_wkrestapi_catalog->productManufacturer();

            if ($manufacturers) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($manufacturers));
            } else {
                $return_array = array(
                    'error' => 1,
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Fetches the manufacturer's info
     * @param  json $data contains manufacturer ID
     * @return json       returns manufacturer info
     */
    public function manufacturerInfo()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $manufacturerData = array();

            foreach ($post as $key => $value) {
                $manufacturerData[$key] = $value;
            }

            if (!isset($manufacturerData['width'])) {
                $manufacturerData['width'] = 100;
            }

            $this->load->model('wkrestapi/catalog');

            $manufacturers = $this->model_wkrestapi_catalog->manufacturerInfo($manufacturerData);

            if ($manufacturers) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($manufacturers));
            } else {
                $return_array = array(
                    'error' => 1,
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    /**
     * Search Suggestion
     * @param  json $data contains search string
     * @return json       return error if exists
     */
    public function searchSuggest()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $search_data = array();

            foreach ($post as $key => $value) {
                $search_data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (isset($search_data) && is_array($search_data)) {
                $search_data['search'] = urldecode($search_data['search']);
            }
            $searchSuggest = $this->model_wkrestapi_catalog->getsearchSuggest($search_data);

            if ($searchSuggest) {
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($searchSuggest));
            } else {
                $return_array = array(
                    'error' => 1,
                );
                $this->response->addHeader('Content-Type: application/json');
                $this->response->setOutput(json_encode($return_array));
            }
        }
    }

    public function addToComparelist()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $this->load->language('product/compare');

            $json = array();

            if (!isset($this->session->data['compare'])) {
                $this->session->data['compare'] = array();
            }

            if (isset($this->request->post['product_id'])) {
                $product_id = $this->request->post['product_id'];
            } else {
                $product_id = 0;
            }

            $this->load->model('catalog/product');

            $product_info = $this->model_catalog_product->getProduct($product_id);

            if ($product_info) {
                if (!in_array($this->request->post['product_id'], $this->session->data['compare'])) {
                    if (count($this->session->data['compare']) >= 4) {
                        array_shift($this->session->data['compare']);
                    }

                    $this->session->data['compare'][] = $this->request->post['product_id'];
                }

                $json['error'] = 0;

                $json['message'] = "You have modified your compare list!";

                $json['total'] = sprintf($this->language->get('text_compare'), (isset($this->session->data['compare']) ? count($this->session->data['compare']) : 0));
            } else {
                $json['error'] = 1;

            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($json));

        }

    }

    public function productCompare()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $data = array();

            $this->load->language('product/compare');

            $this->load->model('catalog/product');

            $this->load->model('tool/image');

            if (isset($this->session->data['compare']) && $this->session->data['compare']) {

                foreach ($this->session->data['compare'] as $key => $product_id) {

                    $product_info = $this->model_catalog_product->getProduct($product_id);

                    if ($product_info) {
                        if ($product_info['image']) {
                            $image = $this->model_tool_image->resize($product_info['image'], $this->config->get('theme_' . $this->config->get('config_theme') . '_image_compare_width'), $this->config->get('theme_' . $this->config->get('config_theme') . '_image_compare_height'));
                        } else {
                            $image = false;
                        }

                        if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
                            $price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
                        } else {
                            $price = false;
                        }

                        if (!is_null($product_info['special']) && (float) $product_info['special'] >= 0) {
                            $special = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
                        } else {
                            $special = false;
                        }

                        if ($product_info['quantity'] <= 0) {
                            $availability = $product_info['stock_status'];
                        } elseif ($this->config->get('config_stock_display')) {
                            $availability = $product_info['quantity'];
                        } else {
                            $availability = $this->language->get('text_instock');
                        }

                        $this->load->model('wkrestapi/catalog');

                        $attribute_data = array();

                        $attribute_groups = $this->model_catalog_product->getProductAttributes($product_id);

                        foreach ($attribute_groups as $attribute_group) {
                            foreach ($attribute_group['attribute'] as $attribute) {
                                $attribute_data[$attribute['attribute_id']] = $attribute['text'];
                            }
                        }

                        $result = $this->model_wkrestapi_catalog->getProduct($product_id);

                        unset($result['langArray']);
                        unset($result['relatedProducts']);

                        $data['error'] = 0;
                        $data['products'][] = $result;

                        foreach ($attribute_groups as $attribute_group) {
                            $data['attribute_groups'][$attribute_group['attribute_group_id']]['name'] = $attribute_group['name'];

                            foreach ($attribute_group['attribute'] as $attribute) {
                                $data['attribute_groups'][$attribute_group['attribute_group_id']]['attribute'][$attribute['attribute_id']]['name'] = $attribute['name'];
                            }
                        }
                    } else {
                        unset($this->session->data['compare'][$key]);
                    }
                }
            } else {
                $data['error'] = 1;
                $data['message'] = "No product to compare";

            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($data));

        }

    }

    public function removeProductCompare()
    {
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $this->load->language('product/compare');

            $this->load->model('catalog/product');

            $this->load->model('tool/image');

            if (!isset($this->session->data['compare'])) {
                $this->session->data['compare'] = array();
            }
            $data = array();

            if (isset($this->request->get['remove'])) {
                $key = array_search($this->request->get['remove'], $this->session->data['compare']);

                if ($key !== false) {
                    unset($this->session->data['compare'][$key]);

                    $data['error'] = 0;
                    $data['success'] = $this->language->get('text_remove');
                }

            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($data));

        }

    }

    public function returnGuestOrder(){
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }
        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('error' => 1, 'message' => $this->language->get('text_token_message'))));
        }else{

            if (isset($post['order_id'])) {
                $order_id = $post['order_id'];
            } else {
                $order_id = 0;
            }

            if (isset($post['lastname'])) {
                $lastname = $post['lastname'];
            } else {
                $lastname = '';
            }

            if (isset($post['email'])) {
                $email = $post['email'];
            } else {
                $email = '';
            }
            if (isset($post['zip'])) {
                $zip = $post['zip'];
            } else {
                $zip = '';
            }

            if (isset($post['model'])) {
                $model = $post['model'];
            } else {
                $model = '';
            }

            $sql = "SELECT * FROM `" . DB_PREFIX . "order` WHERE order_id = '" . (int) $order_id . "' AND lastname = '" . $lastname . "' AND order_status_id > '0' AND customer_id = '0'";

            if ($email) {
                $sql .= " AND email = '" . $email . "'";
            } else {
                $sql .= " AND payment_postcode = '" . $zip . "'";
            }
            $order_query = $this->db->query($sql);

            if($order_query->num_rows){
                $order_product_id = $this->db->query("SELECT * FROM " . DB_PREFIX . "order_product where order_id = '" . (int) $order_id . "' AND model = '" . $model . "'");
                if($order_product_id->num_rows){
                    $order_product_id = $order_product_id->row;

                    $return_array = array(
                        'order_id' => $order_id,
                        'product_id' => isset($order_product_id['product_id']) ? $order_product_id['product_id'] : '',
                        'customer_id' => $order_query->row['customer_id'],
                        'firstname' => $order_query->row['firstname'],
                        'lastname' => $order_query->row['lastname'],
                        'email' => $order_query->row['email'],
                        'telephone' => isset($post['telephone']) ? $post['telephone'] : '',
                        'product' => isset($post['product']) ? $post['product'] : '',
                        'model' => $model,
                        'quantity' => isset($post['quantity']) ? $post['quantity'] : '',
                        'opened' => isset($post['opened']),
                        'return_reason_id' => isset($post['return_reason_id']) ? $post['return_reason_id'] : '',
                        'comment' => nl2br($post['comment']),
                        'date_ordered' => $order_query->row['date_added']
                    );
                    $this->load->model('account/return');
                    $this->model_account_return->addReturn($return_array);
                    $return_message = array(
                        'success' => 1,
                        'message' => $this->language->get('order_return_success'),
                    );
                }else{
                    $return_message = array(
                        'error' => 1,
                        'message' => $this->language->get('order_return_error'),
                    );
                }
            }else{
                $return_message = array(
                    'error' => 1,
                    'message' => $this->language->get('text_order_message'),
                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_message));
        }
    }

    public function getGuestOrder()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('error' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            if (isset($post['order_id'])) {
                $order_id = $post['order_id'];
            } else {
                $order_id = 0;
            }

            if (isset($post['lastName'])) {
                $lastName = $post['lastName'];
            } else {
                $lastName = '';
            }

            if (isset($post['email'])) {
                $email = $post['email'];
            } else {
                $email = '';
            }
            if (isset($post['zip'])) {
                $zip = $post['zip'];
            } else {
                $zip = '';
            }

            $sql = "SELECT * FROM `" . DB_PREFIX . "order` WHERE order_id = '" . (int) $order_id . "' AND lastname = '" . $lastName . "' AND order_status_id > '0' AND customer_id = '0'";

            if ($email) {
                $sql .= " AND email = '" . $email . "'";
            } else {
                $sql .= " AND payment_postcode = '" . $zip . "'";
            }

            $order_query = $this->db->query($sql);

            if ($order_query->num_rows) {
                $country_query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "country` WHERE country_id = '" . (int) $order_query->row['payment_country_id'] . "'");

                if ($country_query->num_rows) {
                    $payment_iso_code_2 = $country_query->row['iso_code_2'];
                    $payment_iso_code_3 = $country_query->row['iso_code_3'];
                } else {
                    $payment_iso_code_2 = '';
                    $payment_iso_code_3 = '';
                }

                $zone_query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "zone` WHERE zone_id = '" . (int) $order_query->row['payment_zone_id'] . "'");

                if ($zone_query->num_rows) {
                    $payment_zone_code = $zone_query->row['code'];
                } else {
                    $payment_zone_code = '';
                }

                $country_query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "country` WHERE country_id = '" . (int) $order_query->row['shipping_country_id'] . "'");

                if ($country_query->num_rows) {
                    $shipping_iso_code_2 = $country_query->row['iso_code_2'];
                    $shipping_iso_code_3 = $country_query->row['iso_code_3'];
                } else {
                    $shipping_iso_code_2 = '';
                    $shipping_iso_code_3 = '';
                }

                $zone_query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "zone` WHERE zone_id = '" . (int) $order_query->row['shipping_zone_id'] . "'");

                if ($zone_query->num_rows) {
                    $shipping_zone_code = $zone_query->row['code'];
                } else {
                    $shipping_zone_code = '';
                }

                $return_array = array(
                    'order_id' => $order_query->row['order_id'],
                    'invoice_no' => $order_query->row['invoice_no'],
                    'invoice_prefix' => $order_query->row['invoice_prefix'],
                    'store_id' => $order_query->row['store_id'],
                    'store_name' => $order_query->row['store_name'],
                    'store_url' => $order_query->row['store_url'],
                    'customer_id' => $order_query->row['customer_id'],
                    'firstname' => $order_query->row['firstname'],
                    'lastname' => $order_query->row['lastname'],
                    'telephone' => $order_query->row['telephone'],
                    'email' => $order_query->row['email'],
                    'payment_firstname' => $order_query->row['payment_firstname'],
                    'payment_lastname' => $order_query->row['payment_lastname'],
                    'payment_company' => $order_query->row['payment_company'],
                    'payment_address_1' => $order_query->row['payment_address_1'],
                    'payment_address_2' => $order_query->row['payment_address_2'],
                    'payment_postcode' => $order_query->row['payment_postcode'],
                    'payment_city' => $order_query->row['payment_city'],
                    'payment_zone_id' => $order_query->row['payment_zone_id'],
                    'payment_zone' => $order_query->row['payment_zone'],
                    'payment_zone_code' => $payment_zone_code,
                    'payment_country_id' => $order_query->row['payment_country_id'],
                    'payment_country' => $order_query->row['payment_country'],
                    'payment_iso_code_2' => $payment_iso_code_2,
                    'payment_iso_code_3' => $payment_iso_code_3,
                    'payment_address_format' => $order_query->row['payment_address_format'],
                    'payment_method' => $order_query->row['payment_method'],
                    'shipping_firstname' => $order_query->row['shipping_firstname'],
                    'shipping_lastname' => $order_query->row['shipping_lastname'],
                    'shipping_company' => $order_query->row['shipping_company'],
                    'shipping_address_1' => $order_query->row['shipping_address_1'],
                    'shipping_address_2' => $order_query->row['shipping_address_2'],
                    'shipping_postcode' => $order_query->row['shipping_postcode'],
                    'shipping_city' => $order_query->row['shipping_city'],
                    'shipping_zone_id' => $order_query->row['shipping_zone_id'],
                    'shipping_zone' => $order_query->row['shipping_zone'],
                    'shipping_zone_code' => $shipping_zone_code,
                    'shipping_country_id' => $order_query->row['shipping_country_id'],
                    'shipping_country' => $order_query->row['shipping_country'],
                    'shipping_iso_code_2' => $shipping_iso_code_2,
                    'shipping_iso_code_3' => $shipping_iso_code_3,
                    'shipping_address_format' => $order_query->row['shipping_address_format'],
                    'shipping_method' => $order_query->row['shipping_method'],
                    'comment' => $order_query->row['comment'],
                    'total' => $order_query->row['total'],
                    'order_status_id' => $order_query->row['order_status_id'],
                    'language_id' => $order_query->row['language_id'],
                    'currency_id' => $order_query->row['currency_id'],
                    'currency_code' => $order_query->row['currency_code'],
                    'currency_value' => $order_query->row['currency_value'],
                    'date_modified' => $order_query->row['date_modified'],
                    'date_added' => $order_query->row['date_added'],
                    'ip' => $order_query->row['ip'],
                    'success' => 1,
                    'message' => $this->language->get('get_guest_order'),
                );

            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_order_message'),
                );
            }

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        }
    }

    protected function checkSession($session_id)
    {

        if (version_compare(VERSION, '3.0.0.0', '>=')) {
            if (isset($this->session->data['session_id']) && $this->session->data['session_id'] == $session_id) {
                return true;
            }
        } else {
            foreach ($_SESSION as $key => $value) {
                if (isset($value['session_id']) && $session_id == $value['session_id']) {
                    return true;
                }
            }

            if (isset($_SESSION['session_id']) && $_SESSION['session_id'] == $session_id) {
                return true;
            }
        }
        return false;
    }
}
if (!function_exists('getallheaders')) {
    function getallheaders()
    {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (substr($name, 0, 5) == 'HTTP_') {
                $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
            }
        }
        return $headers;
    }
}
