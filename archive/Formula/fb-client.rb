class FbClient < Formula
  include Language::Python::Shebang

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.1.1.tar.gz"
  sha256 "8fbcffc853b298a8497ab0f66b254c0c9ae4cbd31ab9889912a44a8c5c7cef0e"
  license "GPL-3.0-only"
  revision 3
  head "https://git.server-speed.net/users/flo/fb", using: :git, branch: "master"

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fb-client"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a85a54c4d1b566b683eb02588357a2b5e163ef5e9136dabe6f4473fa0226bc70"
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "python@3.10"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/50/1a/35b1d8b8e4e23a234f1b17a8a40299fd550940b16866c9a1f2d47a04b969/pycurl-7.43.0.6.tar.gz"
    sha256 "8301518689daefa53726b59ded6b48f33751c383cf987b0ccfbbc4ed40281325"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages("python3")

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor"),
                        "--curl-config=#{Formula["curl"].opt_bin}/curl-config"
    end

    resource("pyxdg").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    rewrite_shebang detected_python_shebang, "fb"

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"fb", "-h"
  end
end
