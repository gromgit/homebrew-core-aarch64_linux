class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.8/pgloader-bundle-3.6.8.tgz"
  sha256 "879bc1f8a39aa5b5ec49534855612c69a9f27336827e5f35f925dd88d98d6e81"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "e8f8544529e1d6c8934f17c5c92c5bad0ee1082a4366b65e2dd534f9d8d378f3"
    sha256 cellar: :any, arm64_big_sur:  "449f4d45a3ff33c3bbedaa299763a90b13a6dd150826ed83f8fae1fdf0fb89c3"
    sha256 cellar: :any, monterey:       "b262feb4f5af872aed21e8b49a307c562f749b9282d81bf15275b340ec864690"
    sha256 cellar: :any, big_sur:        "e0e509ad7d4cb90507d6fcf47f41c55b70157d4877cced859977c4453aab6f50"
    sha256 cellar: :any, catalina:       "a65ab10ee01510e3d2fa664d3049fe116dc09a5d6580f3ef28302dae4584346f"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end
