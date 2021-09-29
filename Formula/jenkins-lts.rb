class JenkinsLts < Formula
  desc "Extendable open-source CI server"
  homepage "https://www.jenkins.io/index.html#stable"
  url "https://get.jenkins.io/war-stable/2.303.1/jenkins.war"
  sha256 "4aae135cde63e398a1f59d37978d97604cb595314f7041d2d3bac3f0bb32c065"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c2793eba19b213fe74ec7b064f9a67958b858380a168c22a15f0b3da9ed925e6"
  end

  depends_on "openjdk@11"

  def install
    system "#{Formula["openjdk@11"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", java_version: "11"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", java_version: "11"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@11"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins-lts --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
