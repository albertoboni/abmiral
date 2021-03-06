module Abmiral

  # Each order is a single ab run to the target url. Each order generates a crontab entry.
  # It generates a single output csv file.
  class Order

    attr_reader   :name, :url, :date, :requests, :concurrency, :hq

    # Well...
    #
    # @param [String] name        The test name
    # @param [String] url         The url to be requested
    # @param [String] date        The DateTime to run the test on
    # @param [String] requests    The total of requests to be made
    # @param [String] concurrency The number of concurrent requests to be made
    # @param [String] hq          Were all the outputs should go to
    def initialize(name, url, date, requests, concurrency, hq)
      date = Time.parse(date) unless date.is_a? Time

      @name        = name
      @url         = url
      @requests    = requests
      @concurrency = concurrency
      @date        = date
      self.hq      = hq
    end

    # Setter for @hq, and makes sure the string ends with a trailing slash
    #
    # @param [String] hq
    def hq=(hq)
      @hq = String(hq)
      @hq << '/' unless /\/\z/.match @hq
    end


    # Fetches the contab entry for this order, with the set time, command and logging
    #
    # @return [String]
    def briefing
      "#{date.min} #{date.hour} #{date.day} #{date.month} 0     #{ab_command}"
    end

    # Fetches the ab command to be executed
    #
    # @return [String]
    def ab_command
      "ab -r -e #{export_file_name} -n #{requests} -c #{concurrency} #{url}"
    end

    # Fetches the file name to ab output to
    #
    # @return [String]
    def export_file_name
      "#{@hq}#{name}.#{requests}-#{concurrency}.csv"
    end

  end
end