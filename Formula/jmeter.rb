class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.3.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.3.tgz"
  sha256 "d0611b46268c4e24220fed56e76d770077713ff863665c271ed6521046f2f0d0"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "35782a22fb9fb63892756bc44e05e1e231997549e3bbf69674dd8fb86e814de9" => :big_sur
    sha256 "3acc6eb0511d25a8181113baafe6886ef137167205b9a0ebc116463e6ec3b01c" => :catalina
    sha256 "02634135916cb0aa45ed91c073ffba66824b8fd2609cd65d491e894cdae0b7e3" => :mojave
    sha256 "ffd194e084e78018d51d80129c22f424db57eaddad21990af6a9c8dd8d617a42" => :high_sierra
  end

  depends_on "openjdk"

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.4/jmeter-plugins-manager-1.4.jar"
    sha256 "473697bd4656e3277b2ba6e23ff023209db4f13524995fa18e4acabca0fc4425"
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
