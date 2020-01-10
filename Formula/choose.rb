class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  revision 2
  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87e8d6d46a55d17be3b4876fa96e83a2585206ea9ccbde7edb7e2d9b0d3c345d" => :catalina
    sha256 "dba7080c2cbfec86cece9b777e0e8bbddc978d9d16869d8c40dedca3db5fa2f7" => :mojave
    sha256 "0798c4a91ff53f4ab075f9509c20fa40c809d7d692be156089e934673a6d73f8" => :high_sierra
    sha256 "9a91c98c4f1ff7d3a639e324d7926d39b21fca78cb32d2ef153510ac8d2306e1" => :sierra
  end

  depends_on "python@3.8"

  conflicts_with "choose-gui", :because => "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    resource("urwid").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    bin.install "choose"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    assert_predicate bin/"choose", :executable?
  end
end
