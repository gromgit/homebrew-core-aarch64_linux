class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.3.3.tar.gz"
  sha256 "8594948ebfc0d4f311a2f0a2261a0397b190500f33492c5bf647b3e07b8b625d"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84580bda78971f31534c6caf48c12f2cbfedcc359d68dcf094d89e263d1fa8c9" => :big_sur
    sha256 "a3e4ee0c52c10a093b7f98155b0c703706f8672bd2997aec587519911f6d292e" => :arm64_big_sur
    sha256 "923ff33a2daf927dbc8932be5ce48ea831dee75856fbba608cd9b92337e14609" => :catalina
    sha256 "553ff98671692fb3e8e6f5fe067b9bfe9ea9ab219936e235be1ac7976fde00b8" => :mojave
  end

  depends_on "ruby"

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.7.gem"
    sha256 "8fc35d22ba7a386adecb728e68908e98b6a076340aaec6c654583a93ca9faadf"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.3.0.gem"
    sha256 "909af322005817dfd848afb85ba5a30c65c38299b288349ac8c1744607391d62"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.1.gem"
    sha256 "ec0bab47f397b32d09b599629cf32f4fc922470a09bef602ef5e492127bb263f"
  end

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.10.gem"
    sha256 "67df9f52c5fdeb7b2b8ce42156f9d019c1c4eb643481a68149ff6c0b65bc613c"
  end

  # Fix Ruby 3 syntax errors
  # https://github.com/coinbase/terraform-landscape/pull/118
  patch do
    url "https://github.com/coinbase/terraform-landscape/commit/29b07f3c0a23e00b10d8ea3ed018a1cb5805689e.patch?full_index=1"
    sha256 "ea651dc182bbd4cfddfbec098d641657097270eceb0c056a38a0f34286ef1144"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
                    "--ignore-dependencies", "--install-dir", libexec
    end
    system "gem", "build", "terraform_landscape.gemspec"
    system "gem", "install", "--ignore-dependencies", "terraform_landscape-#{version}.gem"
    bin.install libexec/"bin/landscape"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/landscape -v")
    assert_match "Terraform Landscape #{version}", output

    test_input = "+ some_resource_type.some_resource_name"
    colorized_expected_output = "\e[0;32;49m+ some_resource_type.some_resource_name\e[0m\n\n\n"

    output = shell_output("echo '#{test_input}' | #{bin}/landscape")
    assert_match colorized_expected_output, output
  end
end
