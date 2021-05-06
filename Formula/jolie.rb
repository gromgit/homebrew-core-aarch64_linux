class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https://www.jolie-lang.org/"
  url "https://github.com/jolie/jolie/releases/download/v1.10.0/jolie-1.10.0.jar"
  sha256 "d50c3ac2f5567c2fb04880bcf8466b3822dfae31c540dae1ee49a8162969bc3d"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "293bd55cf621f0231521549245060fb5b4fe2bd422df6ea6436965b849227147"
  end

  depends_on "openjdk"

  def install
    system Formula["openjdk"].opt_bin/"java",
    "-jar", "jolie-#{version}.jar",
    "--jolie-home", libexec,
    "--jolie-launchers", libexec/"bin"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin",
      JOLIE_HOME: "${JOLIE_HOME:-#{libexec}}",
      JAVA_HOME:  "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    file = testpath/"test.ol"
    file.write <<~EOS
      include "console.iol"

      interface EchoInterface {
        OneWay: echo( int )
      }

      inputPort In {
        location: "local://testPort"
        interfaces: EchoInterface
      }

      outputPort Self {
        location: "local://testPort"
        interfaces: EchoInterface
      }

      init{
        echo@Self( 4 )
      }

      main {
        echo( x )
        println@Console( x * x )()
      }
    EOS

    out = shell_output("#{bin}/jolie #{file}").strip

    assert_equal "16", out
  end
end
