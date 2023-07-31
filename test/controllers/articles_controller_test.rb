require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new if author or admin" do
    sign_in users(:author)
    get new_article_url
    assert_response :success
  end

  test "should redirect get new if user" do
    sign_in users(:user)
    get new_article_url
    assert_response :redirect
  end

  test "should create article if author or admin" do
    sign_in users(:author)
    assert_difference("Article.count") do
      post articles_url, params: { article: { content: @article.content, image: @article.image, title: @article.title } }
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should not create article if user" do
    sign_in users(:user)
    assert_no_difference "Article.count" do
      post articles_url, params: { article: { content: @article.content, image: @article.image, title: @article.title } }
    end

    assert_redirected_to articles_path
  end

  test "should get edit if admin" do
    sign_in users(:admin)
    get edit_article_url(@article)
    assert_response :success
  end

  test "should redirect get edit if user or author" do
    sign_in users(:author)
    get edit_article_url(@article)
    assert_response :redirect
  end

  test "should update article if admin" do
    sign_in users(:admin)
    Article.create(title: 'original', content: 'original', image: 'original', user_id: users(:admin).id)
    assert_changes -> { Article.last.content }, to: 'updated' do
      patch article_url(Article.last), params: { article: { content: 'updated', image: 'updated', title: 'updated' } }
    end
  end

  test "should not update article if user or author" do
    sign_in users(:author)
    Article.create(title: 'original', content: 'original', image: 'original', user_id: users(:author).id)
    assert_no_changes -> { Article.last.content }, from: 'original' do
      patch article_url(Article.last), params: { article: { content: 'updated', image: 'updated', title: 'updated' } }
    end
  end

  test "should destroy article if admin" do
    sign_in users(:admin)
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end

  test "should not destroy article if user or author" do
    sign_in users(:author)
    assert_no_difference "Article.count" do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end
end
