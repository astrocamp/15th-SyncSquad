# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 使用軟刪除套件
  acts_as_paranoid
  
  # Relationship
  has_many :events

  # Get users without appointment/special user
  # scope 是一個 Rails 中用於定義範圍的方法。
  # :all_except 是這個範圍的名稱。
  # ->(user) { ... } 是一個 Lambda 函式，它接受一個參數 user。
  # where.not(id: user) 它會從查詢結果中排除具有特定 id 的用戶。
  scope :all_except, ->(user) { where.not(id: user) }
  # after_create_commit 自訂一個callback發生在create之後
  # broadcast_append_to broadcast_append_to 是一個用於廣播的方法。
  # 它將新創建的物件追加到前端與 'users' 標籤相關聯的部分
  after_create_commit { broadcast_append_to 'users' }
  has_many :messages
end
