require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.4.tgz"
  sha256 "236b290b1fe762da1761a50f8df521a2d45466f94315039f85e3c7f946f95b9e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c35178d2999dafde1782be1ce343c52a83b9c5d98c547a9b69318e12c6883ffc" => :catalina
    sha256 "ac31ac32a75c9455c7e3530fb0b0fb57bacbdb7ab675079757db0e1b541e8d84" => :mojave
    sha256 "7ef414f012ef8a91a4f449423df522a14598f6e1728265ab48ede61b2e41e5c3" => :high_sierra
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
