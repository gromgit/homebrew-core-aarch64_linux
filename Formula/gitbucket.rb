class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://github.com/gitbucket/gitbucket"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.38.0/gitbucket.war"
  sha256 "27293ec17301c6a5ef364c8303b8b48f15a351e0b5d375a5d61b62fed41e5496"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gitbucket"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d763e3ffde08a01a4c13456375cd0dce22a2ca153aadcbdf41244d60f73e43e3"
  end

  head do
    url "https://github.com/gitbucket/gitbucket.git", branch: "master"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "sbt", "executable"
      libexec.install "target/executable/gitbucket.war"
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
