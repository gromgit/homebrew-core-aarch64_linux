class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/41/9d/62a756d0b68ce9dc09afae42249042879d7a3746fc3b55550770de68114e/coconut-2.0.0.tar.gz"
  sha256 "a0b05cef7eca57cd21070fa9f3c8a80303ef5c7ef35d7cd7abdaf02f0ea8e5ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf9034c5b5b94dee1de53be9b97a33ba623a48f0967c2ff929626158c0d4b08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6afe30389ae032a02ad12ff00467fe3c00a5c065c5f820f138c4e0cf470e21d8"
    sha256 cellar: :any_skip_relocation, monterey:       "8f815cfcbd805d36c5bfaad6adbd376c6f5bdfc509fa87d649d886732ac65b7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a75b0b64513f08188edaf8a71ce67ae5bb079b0f84ae26ac8350e49bed1fbb4d"
    sha256 cellar: :any_skip_relocation, catalina:       "9421be5096552a612d6b2535272526f9b88cd55d162a3107aa852692b008599a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd6bcfb975f9e7532ea5d95596efe57dca7bef8831d9ae020ccc8d6233603e9"
  end

  depends_on "pygments"
  depends_on "python@3.10"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/a9/70/b40155e3dc29492a5c3e3bdb8650164816dc112417cf9d56313ba9ce8b41/cPyparsing-2.4.7.1.1.0.tar.gz"
    sha256 "c533dcc81ef855e46a741e552a6f5a30b7aa7af417313cc8d4ea077034abdd77"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
