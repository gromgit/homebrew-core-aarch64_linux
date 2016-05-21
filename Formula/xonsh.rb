class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/scopatz/xonsh/archive/0.3.0.tar.gz"
  sha256 "6553d95f1e52a664a5b15ff096ecf09d9d970d18dfd7bd577ad1132e7348bbca"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f63e1dc5c0243f229801faa60d08d55e175e6cda4714959dfdf1e5bd337198c" => :el_capitan
    sha256 "543579d5a0e05ee472eae1edf7db2fd704f9c22cf9ab1ee10349322b5c57e2c9" => :yosemite
    sha256 "0ffc337f17489209332fe99df963170045ea7c85cc36d5d8aca52d89feb5102a" => :mavericks
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/source/p/ply/ply-3.8.tar.gz"
    sha256 "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resource("ply").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
