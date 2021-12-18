class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.4.2.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.2.tgz"
  sha256 "aedbfaf000aa2d19e3534cc4062acb9f97308711b2d37ba965643222a7840b10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38620505fcd2ce0c6eeafe1c49f6b295fa4ab81857ddc8d181774d9f6b2ff356"
  end

  depends_on "openjdk"

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.6/jmeter-plugins-manager-1.6.jar"
    sha256 "6f391eb6c935bd63ff9e356fb5f353d3c80b27bb762fcb5ce2c0c88f71fbd514"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"jmeter").write_env_script libexec/"bin/jmeter", JAVA_HOME: Formula["openjdk"].opt_prefix

    resource("jmeter-plugins-manager").stage do
      (libexec/"lib/ext").install Dir["*"]
    end
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
