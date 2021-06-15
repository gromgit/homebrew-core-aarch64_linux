class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://github.com/gitbucket/gitbucket"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.35.3/gitbucket.war"
  sha256 "19cf2233f76171beda543fa11812365f409f807c07210ab83d57cb8252d66ebe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d993565ae3717b98cb81878650164ba91c8af24d2238d78d1999640b49c54b3a"
  end

  head do
    url "https://github.com/gitbucket/gitbucket.git"
    depends_on "ant" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "ant"
      libexec.install "war/target/gitbucket.war", "."
    else
      libexec.install "gitbucket.war"
    end
  end

  def caveats
    <<~EOS
      Note: When using `brew services` the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"gitbucket.war",
         "--host=127.0.0.1", "--port=8080"]
  end

  test do
    java = Formula["openjdk"].opt_bin/"java"
    fork do
      $stdout.reopen(testpath/"output")
      exec "#{java} -jar #{libexec}/gitbucket.war --port=#{free_port}"
    end
    sleep 12
    File.read("output") !~ /Exception/
  end
end
