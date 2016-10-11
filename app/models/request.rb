require 'csv'

class Request < ApplicationRecord
  belongs_to :user
  belongs_to :admin, :class_name => 'User'
  belongs_to :room

  scope :current_month, -> { where(date: Time.now.at_beginning_of_month..Time.now.at_end_of_month) }
  scope :next_month, -> { where(date: Time.now.next_month.at_beginning_of_month..Time.now.next_month.at_end_of_month) }

  def self.to_csv(requests)
    headers = %w(No 残留日 残留者ユーザID 場所コード 建物コード 理由 その他 申請日 申請者ユーザID Ｒ更新者 Ｒ更新日付 Ｒ更新時刻)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      requests.each do |request|
        csv << [
            '',
            request.date.strftime('%Y/%m/%d'),
            request.user.student_id,
            request.room.code,
            request.room.building_code,
            '1',
            '',
            request.admin.admin_code,
            '',
            '',
            ''
        ]
      end
    end
    csv_data.encode(Encoding::SJIS)
  end
end
