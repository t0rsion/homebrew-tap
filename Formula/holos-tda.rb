class HolosTda < Formula
  desc "Vietoris-Rips persistent homology with an implicit ripser-class engine"
  homepage "https://github.com/t0rsion/holos"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.1/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "43ceea4b6ed49153f2333f72f959afe7ba4061b613bfba58d33812a2af52f4ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.1/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "352647f2f1cf6ecf53e908daf3c26b5fd5fabcb1bb3b38733866e26218019723"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.1/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0a2d6e0f1cf70a351ca120d79d5896f7d343242aec38fa18edb3bad5f98c167d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.1/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "41a6b04bbf43611079ad75b99f08c2bec93611f493310d3fae23d52a66dcecbd"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "holos" if OS.mac? && Hardware::CPU.arm?
    bin.install "holos" if OS.mac? && Hardware::CPU.intel?
    bin.install "holos" if OS.linux? && Hardware::CPU.arm?
    bin.install "holos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
