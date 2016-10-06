class SmsNotifier
  cattr_reader :sns, instance_accessor: false do
		Aws::SNS::Client.new
  end

  def self.notify(link)
    sns.publish({
      topic_arn: ENV['AWS_TOPIC'],
      message: "#{link.title}: #{link.url}",
    })
  end
end
