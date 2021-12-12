require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.4.1.tgz"
  sha256 "d8fd75c249f887447daa36a7fee36bd70488030efa5e81981b36880767b8de1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c7dce9e4a627f086c46443cac94678337832bc205e78edb34b0c2a23b542aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9c7dce9e4a627f086c46443cac94678337832bc205e78edb34b0c2a23b542aa"
    sha256 cellar: :any_skip_relocation, monterey:       "0dcd33a02c85c808f780ab336d86d7c99ff00b770d32f20a70f9d519042234c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dcd33a02c85c808f780ab336d86d7c99ff00b770d32f20a70f9d519042234c7"
    sha256 cellar: :any_skip_relocation, catalina:       "0dcd33a02c85c808f780ab336d86d7c99ff00b770d32f20a70f9d519042234c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c7dce9e4a627f086c46443cac94678337832bc205e78edb34b0c2a23b542aa"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
