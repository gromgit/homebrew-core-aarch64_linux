class Screenresolution < Formula
  desc "Get, set, and list display resolution"
  homepage "https://github.com/jhford/screenresolution"
  url "https://github.com/jhford/screenresolution/archive/v1.6.tar.gz"
  sha256 "d3761663eaf585b014391a30a77c9494a6404e78e8a4863383e12c59b0f539eb"
  license "GPL-2.0-only"
  head "https://github.com/jhford/screenresolution.git", branch: "master"

  depends_on :macos

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/screenresolution", "get"
  end
end
